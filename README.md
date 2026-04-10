# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Recommended flow: install `chezmoi`, initialize this repo, then apply the dotfiles. This repo does not provide installer scripts. It is mainly a backup of my personal configuration, and software installation is expected to be guided manually or by an agent reading this README.

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
- Ask the user which config groups they actually want before installing anything.
- Detect the current platform.
- Choose the package manager based on platform.
- Install only the dependencies that are actually needed for the selected configs.
- If the user selects `zsh`, install the zsh-related dependencies first.
- After zsh dependencies are installed, set `zsh` as the default login shell:

```bash
chsh -s "$(command -v zsh)"
```

- Then start a zsh session:

```bash
exec zsh
```

- Treat GUI apps like terminal emulators and GUI editors as manual installs.

### Recommended Dependencies

These are the packages most directly related to the configs in this repo. Install what you actually need for the parts you plan to use:

- Core: `chezmoi`, `zsh`, `oh-my-zsh`, `spaceship-prompt`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- Shell and Git CLI: `gh`, `hub`, `fzf`, `zoxide`, `eza`, `diff-so-fancy`
- CLI tools: `neovim`, `yazi`, `zellij`, `fastfetch`, `btop`, `mpv`, `mediainfo`, `unar`, `exiftool`
- Runtime helpers: `nvm`, `bun`
- Fonts: `Maple Mono NF CN`, `Maple Mono NF`

### Other Config Targets

These configs exist in the repo, but they are manual installs:

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
- **Linux** - system package manager, primarily `apt` and `pacman`, with `dnf` / `zypper` / `apk` as best-effort fallbacks

This repo does not try to automate software installation. VS Code / Cursor config paths are automatically resolved per platform.

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
