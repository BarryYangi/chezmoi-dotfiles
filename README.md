# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Recommended flow: install `chezmoi`, initialize this repo, then apply the dotfiles. For faster setup on your own machines, use the platform-specific bootstrap scripts in [`scripts/`](./scripts).

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

# 3. Apply all managed files
chezmoi apply
```

Works on both **macOS** and **Linux**. The simplest path is to install `chezmoi`, initialize the repo, and run `chezmoi apply`.

### Agent Notes

If an agent is setting up this repo on a machine:

- Read this README first.
- Detect the current platform.
- Use `scripts/bootstrap-macos.sh` on macOS.
- Use `scripts/bootstrap-linux.sh` on Linux.
- `bootstrap-macos.sh` uses Homebrew.
- `bootstrap-linux.sh` auto-detects the system package manager, with primary support for Ubuntu/Debian (`apt`) and Arch Linux (`pacman`).
- `dnf`, `zypper`, and `apk` are best-effort fallbacks only.
- These scripts are for personal bootstrap only. They intentionally install only the base shell experience, CLI tools, `neovim`, `nvm`, `bun`, and Maple Mono fonts.
- They do **not** install heavier GUI software such as editors or terminal emulators.

### Bootstrap Scripts

#### macOS

```bash
bash ./scripts/bootstrap-macos.sh
```

#### Linux

```bash
bash ./scripts/bootstrap-linux.sh
```

The Linux script auto-detects `apt`, `pacman`, `dnf`, `zypper`, or `apk`. It is maintained primarily for Ubuntu/Debian and Arch Linux. Other distros are best-effort only, and unavailable packages should warn and continue.

### Bootstrap Installs

These are the packages the bootstrap scripts are intended to install because they are directly related to the shell experience and CLI configs in this repo:

- Core: `chezmoi`, `zsh`, `oh-my-zsh`, `spaceship-prompt`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Shell and Git CLI: `gh`, `hub`, `fzf`, `zoxide`, `eza`, `diff-so-fancy`
- CLI tools: `neovim`, `yazi`, `zellij`, `fastfetch`, `btop`, `mpv`, `mediainfo`, `unar`, `exiftool`
- Runtime helpers: `nvm`, `bun`
- Fonts: `Maple Mono NF CN`, `Maple Mono NF`

### Other Config Targets

These configs exist in the repo, but the bootstrap scripts intentionally do **not** install them:

- Terminals: `ghostty`, `kitty`, `wezterm`
- Editors: `zed`, `visual-studio-code`, `cursor`

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
