#!/bin/bash

set -e

# ============================================
# Interactive multi-select menu
# Use: Space to toggle, Enter to confirm
# ============================================

OPTIONS=(
  "Shell        oh-my-zsh + spaceship + plugins + eza/zoxide/fzf"
  "Terminals    Ghostty, Kitty, WezTerm"
  "Editors      Neovim, Zed, VS Code, Cursor"
  "CLI Tools    Yazi, Zellij, Fastfetch, Btop"
  "Runtime      nvm, Bun"
)

SELECTED=()
for i in "${!OPTIONS[@]}"; do
  SELECTED[$i]=true
done

CURSOR=0

draw_menu() {
  # Move cursor up to redraw
  if [ "$1" = "redraw" ]; then
    printf "\033[%dA" $((${#OPTIONS[@]} + 2))
  fi

  echo ""
  for i in "${!OPTIONS[@]}"; do
    local marker=" "
    [ "${SELECTED[$i]}" = true ] && marker="●"
    local prefix="  "
    [ "$i" -eq "$CURSOR" ] && prefix="▸ "

    if [ "$i" -eq "$CURSOR" ]; then
      printf "\033[1m%s[%s] %s\033[0m\n" "$prefix" "$marker" "${OPTIONS[$i]}"
    else
      printf "%s[%s] %s\n" "$prefix" "$marker" "${OPTIONS[$i]}"
    fi
  done
  echo ""
  printf "  ↑↓ Move  ␣ Toggle  ⏎ Confirm  a All  n None"
}

select_packages() {
  # Hide cursor
  printf "\033[?25l"
  # Restore cursor on exit
  trap 'printf "\033[?25h"' EXIT

  echo ""
  echo "=========================================="
  echo "  Dotfiles Installer"
  echo "=========================================="
  echo "  Select components to install:"

  draw_menu

  while true; do
    # Read single keypress
    IFS= read -rsn1 key

    case "$key" in
      # Arrow keys (escape sequences)
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') # Up
            ((CURSOR > 0)) && ((CURSOR--))
            ;;
          '[B') # Down
            ((CURSOR < ${#OPTIONS[@]} - 1)) && ((CURSOR++))
            ;;
        esac
        ;;
      # Space - toggle
      ' ')
        if [ "${SELECTED[$CURSOR]}" = true ]; then
          SELECTED[$CURSOR]=false
        else
          SELECTED[$CURSOR]=true
        fi
        ;;
      # Enter - confirm
      '')
        break
        ;;
      # 'a' - select all
      'a'|'A')
        for i in "${!OPTIONS[@]}"; do SELECTED[$i]=true; done
        ;;
      # 'n' - select none
      'n'|'N')
        for i in "${!OPTIONS[@]}"; do SELECTED[$i]=false; done
        ;;
    esac

    draw_menu "redraw"
  done

  # Show cursor again
  printf "\033[?25h"
  echo ""
}

# ============================================
# Install functions
# ============================================
install_brew() {
  for pkg in "$@"; do
    echo "  brew install $pkg"
    brew install "$pkg" 2>/dev/null || true
  done
}

install_cask() {
  for pkg in "$@"; do
    echo "  brew install --cask $pkg"
    brew install --cask "$pkg" 2>/dev/null || true
  done
}

install_shell() {
  echo ""
  echo "Installing Shell..."

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  Installing oh-my-zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
    echo "  Installing spaceship prompt..."
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
      "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
      "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  fi

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

  [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

  install_brew eza zoxide fzf hub diff-so-fancy
}

install_terminals() {
  echo ""
  echo "Installing Terminal Emulators..."
  install_cask ghostty kitty wezterm
}

install_editors() {
  echo ""
  echo "Installing Editors..."
  install_brew neovim
  install_cask zed visual-studio-code cursor
}

install_cli_tools() {
  echo ""
  echo "Installing CLI Tools..."
  install_brew yazi fastfetch btop zellij
}

install_runtime() {
  echo ""
  echo "Installing Runtime..."
  install_brew nvm bun
}

# ============================================
# Main
# ============================================

# Homebrew is always required
if ! command -v brew &>/dev/null; then
  echo "Homebrew is required. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Show interactive menu
select_packages

# Install selected components
INSTALLERS=(install_shell install_terminals install_editors install_cli_tools install_runtime)
INSTALLED=0

for i in "${!INSTALLERS[@]}"; do
  if [ "${SELECTED[$i]}" = true ]; then
    ${INSTALLERS[$i]}
    ((INSTALLED++))
  fi
done

echo ""
if [ "$INSTALLED" -gt 0 ]; then
  echo "Done! Now run 'chezmoi apply' to deploy config files."
  echo "Or apply selectively: chezmoi apply ~/.config/ghostty"
else
  echo "Nothing selected. Run this script again to install components."
fi
