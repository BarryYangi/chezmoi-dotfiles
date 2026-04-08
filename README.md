# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## What's included

### Shell

- **zsh** - Main shell config with oh-my-zsh, spaceship prompt, aliases, and functions

### Terminal Emulators

- **Ghostty** - Primary terminal, with 26 custom shaders
- **Kitty** - Backup terminal with Catppuccin theme
- **WezTerm** - Lua-based terminal config

### Editors

- **Neovim** - AstroNvim setup with custom plugins (copilot, flash, snacks, etc.)
- **Zed** - Settings and keymap
- **VS Code** - Settings
- **Cursor** - Settings

### CLI Tools

- **Yazi** - Terminal file manager with Catppuccin theme
- **Zellij** - Terminal multiplexer with custom keybindings (vim + tmux style)
- **Fastfetch** - System info display with custom logo
- **Btop** - System monitor with Catppuccin theme

### Other

- **gitconfig** - Git global config
- **bunfig.toml** - Bun package manager mirror config
- **Claude** - Claude Code global instructions

## Quick Start

```bash
# Install chezmoi and apply dotfiles
chezmoi init BarryYangi/chezmoi-dotfiles
chezmoi apply
```

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
