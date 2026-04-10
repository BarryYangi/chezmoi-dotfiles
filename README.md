# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Recommended flow: install `chezmoi`, initialize this repo, then apply the dotfiles. Software dependencies can be installed separately with the platform-specific bootstrap commands below.

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

Works on both **macOS** and **Linux**. The simplest path is to install `chezmoi`, initialize the repo, and run `chezmoi apply`. If you want a faster new-machine setup for your own use, use one of the bootstrap command blocks below first.

### Bootstrap Commands

These are convenience commands for your own machines. They install the common tools used by this dotfiles repo, set up oh-my-zsh and its plugins, then initialize and apply chezmoi. They are intentionally explicit and live in the README instead of a maintained installer script.

#### macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)" && \
brew tap homebrew/cask-fonts && \
brew install chezmoi gh hub fzf zoxide eza diff-so-fancy neovim yazi zellij fastfetch btop mpv mediainfo unar exiftool nvm bun && \
brew install --cask ghostty kitty wezterm zed visual-studio-code cursor font-maple-mono-nf-cn font-maple-mono-nf font-annotation-mono && \
if [ ! -d "$HOME/.oh-my-zsh" ]; then RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; fi && \
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}" && \
[ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ] || git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" && \
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && \
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && \
chezmoi init BarryYangi/chezmoi-dotfiles && \
chezmoi apply
```

#### Ubuntu / Debian

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" && \
export PATH="$HOME/.local/bin:$PATH" && \
sudo apt update && \
sudo apt install -y curl git zsh gh hub fzf zoxide neovim zellij fastfetch btop mpv mediainfo unar libimage-exiftool-perl kitty && \
if [ ! -d "$HOME/.oh-my-zsh" ]; then RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; fi && \
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}" && \
[ -d "$ZSH_CUSTOM/themes/spaceship-prompt" ] || git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" && \
ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" && \
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && \
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && \
chezmoi init BarryYangi/chezmoi-dotfiles && \
chezmoi apply
```

Ubuntu/Debian usually still needs some manual extras, depending on distro packages and how closely you want to match the macOS setup:

- `eza`
- `yazi`
- `diff-so-fancy`
- `ghostty`
- `wezterm`
- `zed`
- `visual-studio-code`
- `cursor`
- `Maple Mono NF CN`
- `Maple Mono NF`
- `Annotation Mono`

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
