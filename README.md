# Dotfiles

# Install using stow

```
# Stow configs to ~/.config (ignore home and extra dirs)
stow --target ~/.config --ignore=home --ignore=extra .

# Stow home directory files to ~
stow --target ~ home
```

if stow is not yet available in PATH, use:

```
/opt/homebrew/bin/stow --target ~/.config --ignore=home --ignore=extra .
/opt/homebrew/bin/stow --target ~ home
```
