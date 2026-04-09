#!/bin/bash

set -e

# ============================================
# Helper functions
# ============================================
ask() {
  printf "%s [Y/n] " "$1"
  read -r answer
  case "$answer" in
    [nN]*) return 1 ;;
    *) return 0 ;;
  esac
}

install_brew() {
  for pkg in "$@"; do
    brew install "$pkg" 2>/dev/null || true
  done
}

install_cask() {
  for pkg in "$@"; do
    brew install --cask "$pkg" 2>/dev/null || true
  done
}

# ============================================
# Homebrew
# ============================================
if ! command -v brew &>/dev/null; then
  echo "Homebrew is required. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo ""
echo "=========================================="
echo "  Dotfiles Installer"
echo "=========================================="
echo ""

# ============================================
# Shell (oh-my-zsh + plugins)
# ============================================
if ask "Install Shell (oh-my-zsh + spaceship + plugins)?"; then
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    echo "Installing spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  fi

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  install_brew eza zoxide fzf hub diff-so-fancy
  echo "  Shell done."
fi

# ============================================
# Terminal Emulators
# ============================================
if ask "Install Terminal Emulators (Ghostty, Kitty, WezTerm)?"; then
  install_cask ghostty kitty wezterm
  echo "  Terminal emulators done."
fi

# ============================================
# Editors
# ============================================
if ask "Install Editors (Neovim, Zed, VS Code, Cursor)?"; then
  install_brew neovim
  install_cask zed visual-studio-code cursor
  echo "  Editors done."
fi

# ============================================
# CLI Tools
# ============================================
if ask "Install CLI Tools (Yazi, Zellij, Fastfetch, Btop)?"; then
  install_brew yazi fastfetch btop zellij
  echo "  CLI tools done."
fi

# ============================================
# Runtime
# ============================================
if ask "Install Runtime (nvm, Bun)?"; then
  install_brew nvm bun
  echo "  Runtime done."
fi

echo ""
echo "Done! Now run 'chezmoi apply' to deploy config files."
echo "Or apply selectively: chezmoi apply ~/.config/ghostty"
