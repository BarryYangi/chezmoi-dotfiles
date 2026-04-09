# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Prerequisites

Install [Homebrew](https://brew.sh/) first, then install all dependencies:

```bash
# Core
brew install chezmoi

# Shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install spaceship nvm

# Spaceship prompt symlink
ln -s "$(brew --prefix)/opt/spaceship/spaceship.zsh" \
  "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

# Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Terminal Emulators
brew install --cask ghostty
brew install --cask kitty
brew install --cask wezterm

# Editors
brew install neovim
brew install --cask zed
brew install --cask visual-studio-code
brew install --cask cursor

# CLI Tools
brew install yazi fastfetch btop zellij
brew install eza zoxide fzf
brew install hub diff-so-fancy

# Runtime
brew install nvm bun
```

## Quick Start

```bash
# Apply dotfiles
chezmoi init BarryYangi/chezmoi-dotfiles
chezmoi apply
```

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
