# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Recommended flow: install `chezmoi`, initialize this repo, then run the interactive installer script.

```bash
# 1. Install chezmoi
# macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# Linux (choose the command that matches your distro)
sudo apt install chezmoi
# or
sudo dnf install chezmoi
# or
sudo pacman -S chezmoi
# or
sudo zypper install chezmoi
# or
sudo apk add chezmoi

# 2. Initialize dotfiles
chezmoi init BarryYangi/chezmoi-dotfiles

# 3. Run the installer (recommended)
bash "$(chezmoi source-path)/install.sh"
```

Works on both **macOS** and **Linux**. The recommended entrypoint after `chezmoi init` is the installer script above; it lets you choose which tools to install and automatically applies their configs. On Linux it uses the detected native package manager directly.

The installer provides an interactive menu — use arrow keys to navigate, space to toggle, enter to confirm:

```
── Shell ──────────────────────────────────────────
▸ [●] oh-my-zsh       Shell framework + spaceship prompt + plugins
  [●] eza             Modern ls replacement
  [●] zoxide          Smart cd (z command)
  [●] fzf             Fuzzy finder
  ...
── Terminal Emulators ─────────────────────────────
  [●] Ghostty         GPU-accelerated terminal
  [ ] Kitty           GPU-based terminal
  ...

  ↑↓ Move  ␣ Toggle  ⏎ Confirm  a All  n None
```

### Apply selectively

You can also apply only specific configs without installing everything:

```bash
chezmoi apply ~/.config/ghostty    # Ghostty only
chezmoi apply ~/.config/nvim       # Neovim only
chezmoi apply ~/.zshrc             # zsh only
```

## What's Included

### Shell

- **zsh** - oh-my-zsh + spaceship prompt, git/node aliases, vim-style navigation
- **eza** - Modern ls replacement with icons
- **zoxide** - Smart cd command
- **fzf** - Fuzzy finder with Tokyo Night theme

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

## Supported Platforms

- **macOS** - Homebrew
- **Linux** - system package manager (apt / dnf / pacman / zypper / apk)

On Linux, the installer no longer bootstraps Homebrew and instead uses the detected native package manager directly. Some GUI apps may still need manual installation if your distro does not package them. VS Code / Cursor config paths are automatically resolved per platform.

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
