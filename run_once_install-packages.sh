#!/bin/bash

set -e

echo "🔧 Setting up dotfiles dependencies..."

# ============================================
# Homebrew
# ============================================
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ============================================
# Brew packages
# ============================================
echo "Installing brew packages..."

# Terminal Emulators
brew install --cask ghostty 2>/dev/null || true
brew install --cask kitty 2>/dev/null || true
brew install --cask wezterm 2>/dev/null || true

# Editors
brew install neovim 2>/dev/null || true
brew install --cask zed 2>/dev/null || true
brew install --cask visual-studio-code 2>/dev/null || true
brew install --cask cursor 2>/dev/null || true

# CLI Tools
brew install yazi fastfetch btop zellij 2>/dev/null || true
brew install eza zoxide fzf 2>/dev/null || true
brew install hub diff-so-fancy 2>/dev/null || true

# Runtime
brew install nvm bun 2>/dev/null || true

# ============================================
# Oh My Zsh
# ============================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Spaceship prompt
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
  echo "Installing spaceship prompt..."
  git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
  ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

# Zsh plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "✅ All dependencies installed!"
