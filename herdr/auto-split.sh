#!/bin/sh
pane="${HERDR_ACTIVE_PANE_ID:?}"
dir=$("$HERDR_BIN_PATH" pane layout --pane "$pane" | jq -r --arg p "$pane" '
  .result.layout.panes[] | select(.pane_id == $p) | .rect
  | if .width > 2 * .height then "right" else "down" end')
exec "$HERDR_BIN_PATH" pane split "$pane" --direction "${dir:-right}" --focus
