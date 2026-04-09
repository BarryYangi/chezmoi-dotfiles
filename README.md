# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

### macOS

```bash
brew install chezmoi
chezmoi init BarryYangi/chezmoi-dotfiles
$(chezmoi source-path)/install.sh
```

### Linux

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init BarryYangi/chezmoi-dotfiles
$(chezmoi source-path)/install.sh
```

The installer detects your OS and uses the appropriate package manager (brew / apt / dnf / pacman). It will install selected software and automatically apply their configs.

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

- **macOS** - Full support (Homebrew)
- **Linux** - apt (Ubuntu/Debian), dnf (Fedora), pacman (Arch)

VS Code / Cursor config paths are automatically resolved per platform.

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```
