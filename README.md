# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Recommended flow: install `chezmoi`, initialize this repo, install the tools you want manually, then apply only the configs you want.

```bash
# 1. Install chezmoi
# macOS
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

# Linux
# Ubuntu/Debian (recommended: official installer, since chezmoi is not in all default apt repos)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"

# If ~/.local/bin is not in PATH yet
export PATH="$HOME/.local/bin:$PATH"

# Fedora
sudo dnf install chezmoi
# Arch Linux
sudo pacman -S chezmoi
# openSUSE
sudo zypper install chezmoi
# Alpine
sudo apk add chezmoi
# Alternative for Ubuntu/Debian
sudo snap install chezmoi --classic

# 2. Initialize dotfiles
chezmoi init BarryYangi/chezmoi-dotfiles

# 3. Apply only what you want
chezmoi apply ~/.zshrc
chezmoi apply ~/.config/ghostty
chezmoi apply ~/.config/nvim
```

Works on both **macOS** and **Linux**. After `chezmoi init`, install software dependencies separately with your system package manager, then apply only the files you actually want on that machine.

### Recommended Packages

Install these manually if you want the related configs and aliases to work as intended:

- Shell: `zsh`, `oh-my-zsh`, `gh`, `hub`, `fzf`, `zoxide`, `eza`, `diff-so-fancy`
- Terminals: `ghostty`, `kitty`, `wezterm`
- Editors: `neovim`, `zed`, `visual-studio-code`, `cursor`
- CLI tools: `yazi`, `zellij`, `fastfetch`, `btop`, `mpv`, `mediainfo`, `unar`, `exiftool`
- Runtime: `nvm`, `bun`
- Fonts: `Maple Mono NF CN`, `Maple Mono NF`, `Annotation Mono`

### Apply selectively

You can apply only specific configs without installing everything:

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

Some GUI apps may still need manual installation if your distro does not package them. VS Code / Cursor config paths are automatically resolved per platform.

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
