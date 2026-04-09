# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

```bash
# Install chezmoi
brew install chezmoi

# Init and apply (auto-installs all dependencies on first run)
chezmoi init BarryYangi/chezmoi-dotfiles
chezmoi apply
```

`chezmoi apply` will automatically install:

- **Homebrew** (if not installed)
- **Terminal Emulators** - Ghostty, Kitty, WezTerm
- **Editors** - Neovim, Zed, VS Code, Cursor
- **CLI Tools** - Yazi, Zellij, Fastfetch, Btop, eza, zoxide, fzf, etc.
- **Runtime** - nvm, Bun
- **Oh My Zsh** - with spaceship prompt, zsh-autosuggestions, zsh-syntax-highlighting

## What's Included

### Shell

- **zsh** - oh-my-zsh + spaceship prompt, git/node aliases, vim-style navigation

### Terminal Emulators

- **Ghostty** - Primary terminal with 26 custom shaders
- **Kitty** - Catppuccin theme
- **WezTerm** - Lua-based config

### Editors

- **Neovim** - AstroNvim with plugins (copilot, flash, snacks, telescope, etc.)
- **Zed** - Settings and keymap
- **VS Code / Cursor** - Shared settings

### CLI Tools

- **Yazi** - File manager with Catppuccin theme
- **Zellij** - Terminal multiplexer (vim + tmux keybindings)
- **Fastfetch** - System info with custom logo
- **Btop** - System monitor with Catppuccin theme

### Other

- **bunfig.toml** - Bun npm mirror config (npmmirror.com)
- **Claude** - Claude Code global instructions

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
