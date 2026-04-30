/**
 * Repo Guard Extension
 *
 * Enforces a safe but smooth development experience:
 *
 * - read tool:        always allowed, anywhere (inside or outside repo)
 * - write/edit tools: always allowed inside the git repo;
 *                     requires explicit approval if outside
 * - bash:             commands on the safe allowlist run freely everywhere;
 *                     any mutating command always requires approval,
 *                     with session-level trust options (per-command or all)
 *
 * If not inside a git repo, all write/edit operations require approval.
 * Trust state is session-scoped and resets on each new session.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";
import * as nodePath from "node:path";
import { execSync } from "node:child_process";

// ─── Allowlists ──────────────────────────────────────────────────────────────

/** Root commands considered safe (read-only, non-mutating). */
const SAFE_COMMANDS = new Set([
  // Navigation & discovery
  "ls", "find", "pwd", "which", "whereis", "type", "locate",
  // File reading
  "cat", "head", "tail", "less", "more", "bat",
  // Text processing (non-mutating)
  "grep", "rg", "ag", "awk", "sort", "uniq", "wc",
  "diff", "diff3", "cut", "tr", "strings", "hexdump", "od",
  // System info
  "echo", "printf", "date", "whoami", "uname", "env", "printenv",
  "ps", "file", "stat", "du", "df", "lsof", "id", "uptime",
  // Data
  "jq",
  // Network reads (output-flag variants caught by redirect detection)
  "curl", "wget",
  // Shell control
  "true", "false", "test",
]);

/** git subcommands that are read-only and therefore safe. */
const SAFE_GIT_SUBCOMMANDS = new Set([
  "log", "status", "diff", "show", "branch", "tag", "ls-files",
  "describe", "blame", "shortlog", "rev-parse", "rev-list",
  "cat-file", "ls-tree", "name-rev", "count-objects", "remote",
]);

/** npm / pnpm / yarn subcommands that are read-only. */
const SAFE_NODE_PKG_SUBCOMMANDS = new Set([
  "list", "ls", "outdated", "audit", "view", "info", "show", "ll", "la",
]);

// ─── Bash analysis ───────────────────────────────────────────────────────────

/**
 * Split a bash command string into segments at |, &&, ||, ;
 * Uses a simple quote-aware state machine to avoid splitting inside strings.
 */
function splitSegments(command: string): string[] {
  const segments: string[] = [];
  let current = "";
  let inSingle = false;
  let inDouble = false;

  for (let i = 0; i < command.length; i++) {
    const ch = command[i];
    const next = command[i + 1];

    if (ch === "'" && !inDouble) { inSingle = !inSingle; current += ch; continue; }
    if (ch === '"' && !inSingle) { inDouble = !inDouble; current += ch; continue; }

    if (!inSingle && !inDouble) {
      // && or ||
      if ((ch === "&" && next === "&") || (ch === "|" && next === "|")) {
        segments.push(current.trim());
        current = "";
        i++; // skip the second character
        continue;
      }
      // pipe or semicolon
      if (ch === "|" || ch === ";") {
        segments.push(current.trim());
        current = "";
        continue;
      }
    }

    current += ch;
  }

  if (current.trim()) segments.push(current.trim());
  return segments.filter(Boolean);
}

/**
 * Extract the root command from a segment, skipping leading env var assignments
 * like FOO=bar cmd → cmd.
 */
function getRootCommand(segment: string): string {
  const parts = segment.trim().split(/\s+/);
  for (const part of parts) {
    if (!/^[A-Za-z_][A-Za-z0-9_]*=/.test(part)) return part;
  }
  return parts[0] ?? "";
}

/**
 * Check if a segment contains an output redirect (> or >>).
 * Strips quoted strings first to avoid false positives.
 */
function hasOutputRedirect(segment: string): boolean {
  const stripped = segment.replace(/"(?:[^"\\]|\\.)*"|'[^']*'/g, "__Q__");
  // Match > or >> not preceded by < > 2 & 1 (common redirect qualifiers)
  return /(?<![<>2&1])>{1,2}(?![>=])/.test(stripped);
}

/**
 * Determine if a bash segment is mutating.
 * Returns a short command label used for trust-tracking, or null if safe.
 */
function getMutatingLabel(segment: string): string | null {
  if (!segment) return null;

  // Output redirect anywhere in the segment → mutating
  if (hasOutputRedirect(segment)) return ">";

  // tee writes to a file → mutating
  if (/\btee\b/.test(segment)) return "tee";

  const root = getRootCommand(segment);
  if (!root) return null;

  // Meta-shells: could execute anything → always mutating
  if (["bash", "sh", "zsh", "fish", "dash", "ksh"].includes(root)) return root;

  // xargs: check what command it runs, fallback to mutating
  if (root === "xargs") {
    const match = segment.match(/xargs(?:\s+-\S+)*\s+(\S+)/);
    if (match) {
      const inner = match[1];
      return SAFE_COMMANDS.has(inner) ? null : inner;
    }
    return "xargs";
  }

  // sed -i edits files in-place → mutating despite sed being on the safe list
  if (root === "sed" && /-i\b/.test(segment)) return "sed -i";

  // git: check subcommand
  if (root === "git") {
    const match = segment.match(/git\s+(\S+)/);
    const sub = match?.[1] ?? null;
    if (sub && SAFE_GIT_SUBCOMMANDS.has(sub)) return null;
    return sub ? `git ${sub}` : "git";
  }

  // npm / pnpm / yarn: check subcommand
  if (["npm", "pnpm", "yarn"].includes(root)) {
    const match = segment.match(/(?:npm|pnpm|yarn)\s+(\S+)/);
    const sub = match?.[1] ?? null;
    if (sub && SAFE_NODE_PKG_SUBCOMMANDS.has(sub)) return null;
    return sub ? `${root} ${sub}` : root;
  }

  // Known-safe root command
  if (SAFE_COMMANDS.has(root)) return null;

  // Unknown command → treat as potentially mutating (safe-side default)
  return root;
}

/**
 * Analyze a full bash command and return all mutating labels (deduplicated).
 */
function getMutatingLabels(command: string): string[] {
  const seen = new Set<string>();
  const result: string[] = [];
  for (const segment of splitSegments(command)) {
    const label = getMutatingLabel(segment);
    if (label && !seen.has(label)) {
      result.push(label);
      seen.add(label);
    }
  }
  return result;
}

// ─── Extension ───────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
  let repoRoot: string | null = null;

  // Session-scoped trust state — reset on every session start
  let sessionTrustAllBash = false;
  const sessionTrustedCommands = new Set<string>();

  pi.on("session_start", async (_event, ctx) => {
    sessionTrustAllBash = false;
    sessionTrustedCommands.clear();

    try {
      repoRoot = execSync("git rev-parse --show-toplevel", {
        cwd: ctx.cwd,
        stdio: ["pipe", "pipe", "pipe"],
      })
        .toString()
        .trim();
    } catch {
      repoRoot = null; // Not inside a git repo
    }
  });

  /** Returns true if the given file path resolves to outside the git repo root. */
  function isOutsideRepo(filePath: string, cwd: string): boolean {
    const abs = nodePath.resolve(cwd, filePath);
    if (!repoRoot) return true; // No git repo → treat everything as outside
    return !abs.startsWith(repoRoot + nodePath.sep) && abs !== repoRoot;
  }

  /** Truncate long strings for display in dialogs. */
  function truncate(s: string, max = 120): string {
    return s.length > max ? s.slice(0, max - 1) + "…" : s;
  }

  pi.on("tool_call", async (event, ctx) => {

    // ── read: always allow, anywhere ─────────────────────────────────────────
    if (event.toolName === "read") return undefined;

    // ── write / edit: allow inside repo, ask outside ─────────────────────────
    if (event.toolName === "write" || event.toolName === "edit") {
      const filePath = (event.input as { path: string }).path;

      if (!isOutsideRepo(filePath, ctx.cwd)) return undefined;

      const abs = nodePath.resolve(ctx.cwd, filePath);

      if (!ctx.hasUI) {
        return { block: true, reason: `Write outside repo blocked (no UI): ${abs}` };
      }

      const choice = await ctx.ui.select(
        `⚠️  ${event.toolName} outside repo\n\nPath: ${abs}`,
        ["Allow once", "Deny"],
      );

      if (choice !== "Allow once") {
        return { block: true, reason: `Blocked: ${event.toolName} outside git repo denied by user` };
      }

      return undefined;
    }

    // ── bash: allowlist + per-command trust ───────────────────────────────────
    if (isToolCallEventType("bash", event)) {
      // All bash is trusted for this session
      if (sessionTrustAllBash) return undefined;

      const command = event.input.command;
      const mutating = getMutatingLabels(command);

      // No mutating commands found → safe
      if (mutating.length === 0) return undefined;

      // Filter out already-trusted commands
      const untrusted = mutating.filter((cmd) => !sessionTrustedCommands.has(cmd));
      if (untrusted.length === 0) return undefined;

      if (!ctx.hasUI) {
        return {
          block: true,
          reason: `Mutating bash command blocked (no UI): ${untrusted.join(", ")}`,
        };
      }

      const cmdList = untrusted.join(", ");
      const allowCmdsLabel =
        untrusted.length === 1
          ? `Allow '${untrusted[0]}' for this session`
          : `Allow '${cmdList}' for this session`;

      const options = [
        "Allow once",
        allowCmdsLabel,
        "Allow all bash mutations this session",
        "Deny",
      ];

      const choice = await ctx.ui.select(
        `⚠️  Mutating bash command\n\nCommand:  ${truncate(command)}\nMutating: ${cmdList}`,
        options,
      );

      if (choice === allowCmdsLabel) {
        untrusted.forEach((cmd) => sessionTrustedCommands.add(cmd));
      } else if (choice === "Allow all bash mutations this session") {
        sessionTrustAllBash = true;
      } else if (choice !== "Allow once") {
        // "Deny" or dismissed (null)
        return { block: true, reason: `Blocked: mutating bash command denied by user` };
      }

      return undefined;
    }

    return undefined;
  });
}
