#!/bin/bash

set -e

# ============================================
# Interactive multi-select menu
# Use: Space to toggle, Enter to confirm
# ============================================

LABELS=(
  # Shell
  "oh-my-zsh       Shell framework + spaceship prompt + plugins"
  "eza             Modern ls replacement"
  "zoxide          Smart cd (z command)"
  "fzf             Fuzzy finder"
  "hub             GitHub CLI wrapper"
  "diff-so-fancy   Better git diff"
  # Terminal Emulators
  "Ghostty         GPU-accelerated terminal"
  "Kitty           GPU-based terminal"
  "WezTerm         Lua-configurable terminal"
  # Editors
  "Neovim          Hyperextensible Vim"
  "Zed             High-performance editor"
  "VS Code         Visual Studio Code"
  "Cursor          AI-powered code editor"
  # CLI Tools
  "Yazi            Terminal file manager"
  "Zellij          Terminal multiplexer"
  "Fastfetch       System info display"
  "Btop            System monitor"
  # Runtime
  "nvm             Node version manager"
  "Bun             Fast JS runtime"
)

SELECTED=()
for i in "${!LABELS[@]}"; do
  SELECTED[$i]=true
done

CURSOR=0
TOTAL=${#LABELS[@]}

# Section headers (index -> header)
declare -A HEADERS
HEADERS[0]="── Shell ──────────────────────────────────────────"
HEADERS[6]="── Terminal Emulators ─────────────────────────────"
HEADERS[9]="── Editors ────────────────────────────────────────"
HEADERS[13]="── CLI Tools ──────────────────────────────────────"
HEADERS[17]="── Runtime ────────────────────────────────────────"

count_lines() {
  local lines=$((TOTAL + 3)) # items + header/footer padding
  for key in "${!HEADERS[@]}"; do
    ((lines++))
  done
  echo "$lines"
}

draw_menu() {
  if [ "$1" = "redraw" ]; then
    printf "\033[%dA" "$(count_lines)"
  fi

  echo ""
  for i in "${!LABELS[@]}"; do
    # Print section header
    if [ -n "${HEADERS[$i]}" ]; then
      printf "  \033[2m%s\033[0m\n" "${HEADERS[$i]}"
    fi

    local marker=" "
    [ "${SELECTED[$i]}" = true ] && marker="●"
    local prefix="  "
    [ "$i" -eq "$CURSOR" ] && prefix="▸ "

    if [ "$i" -eq "$CURSOR" ]; then
      printf "\033[1m%s[%s] %s\033[0m\n" "$prefix" "$marker" "${LABELS[$i]}"
    else
      printf "%s[%s] %s\n" "$prefix" "$marker" "${LABELS[$i]}"
    fi
  done
  echo ""
  printf "  ↑↓ Move  ␣ Toggle  ⏎ Confirm  a All  n None"
}

select_packages() {
  printf "\033[?25l"
  trap 'printf "\033[?25h"' EXIT

  echo ""
  echo "=========================================="
  echo "  Dotfiles Installer"
  echo "=========================================="
  echo "  Select components to install:"

  draw_menu

  while true; do
    IFS= read -rsn1 key
    case "$key" in
      $'\x1b')
        read -rsn2 seq
        case "$seq" in
          '[A') ((CURSOR > 0)) && ((CURSOR--)) ;;
          '[B') ((CURSOR < TOTAL - 1)) && ((CURSOR++)) ;;
        esac
        ;;
      ' ')
        if [ "${SELECTED[$CURSOR]}" = true ]; then
          SELECTED[$CURSOR]=false
        else
          SELECTED[$CURSOR]=true
        fi
        ;;
      '')
        break
        ;;
      'a'|'A')
        for i in "${!LABELS[@]}"; do SELECTED[$i]=true; done
        ;;
      'n'|'N')
        for i in "${!LABELS[@]}"; do SELECTED[$i]=false; done
        ;;
    esac
    draw_menu "redraw"
  done

  printf "\033[?25h"
  echo ""
}

# ============================================
# Install functions
# ============================================
install_brew() {
  echo "  brew install $1"
  brew install "$1" 2>/dev/null || true
}

install_cask() {
  echo "  brew install --cask $1"
  brew install --cask "$1" 2>/dev/null || true
}

install_omz() {
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
}

# Map index -> install command
do_install() {
  local i=$1
  case $i in
    0)  install_omz ;;
    1)  install_brew eza ;;
    2)  install_brew zoxide ;;
    3)  install_brew fzf ;;
    4)  install_brew hub ;;
    5)  install_brew diff-so-fancy ;;
    6)  install_cask ghostty ;;
    7)  install_cask kitty ;;
    8)  install_cask wezterm ;;
    9)  install_brew neovim ;;
    10) install_cask zed ;;
    11) install_cask visual-studio-code ;;
    12) install_cask cursor ;;
    13) install_brew yazi ;;
    14) install_brew zellij ;;
    15) install_brew fastfetch ;;
    16) install_brew btop ;;
    17) install_brew nvm ;;
    18) install_brew bun ;;
  esac
}

# Map index -> chezmoi config paths to apply
get_config_paths() {
  local i=$1
  case $i in
    0)  echo "$HOME/.zshrc" ;;
    # 1-5: shell tools, no config files
    6)  echo "$HOME/.config/ghostty" ;;
    7)  echo "$HOME/.config/kitty" ;;
    8)  echo "$HOME/.config/wezterm" ;;
    9)  echo "$HOME/.config/nvim" ;;
    10) echo "$HOME/.config/zed" ;;
    11) echo "$HOME/Library/Application Support/Code/User/settings.json" ;;
    12) echo "$HOME/Library/Application Support/Cursor/User/settings.json" ;;
    13) echo "$HOME/.config/yazi" ;;
    14) echo "$HOME/.config/zellij" ;;
    15) echo "$HOME/.config/fastfetch" ;;
    16) echo "$HOME/.config/btop" ;;
    # 17-18: runtime, no config files
  esac
}

# ============================================
# Main
# ============================================

if ! command -v brew &>/dev/null; then
  echo "Homebrew is required. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

select_packages

echo ""
echo "Installing selected components..."

INSTALLED=0
CONFIG_PATHS=()

for i in "${!LABELS[@]}"; do
  if [ "${SELECTED[$i]}" = true ]; then
    do_install "$i"
    ((INSTALLED++))

    # Collect config paths
    path=$(get_config_paths "$i")
    [ -n "$path" ] && CONFIG_PATHS+=("$path")
  fi
done

# Apply configs
if [ ${#CONFIG_PATHS[@]} -gt 0 ]; then
  echo ""
  echo "Applying configs..."
  # Always apply shared configs
  chezmoi apply "$HOME/.bunfig.toml" "$HOME/.hushlogin" "$HOME/.claude" 2>/dev/null || true
  for path in "${CONFIG_PATHS[@]}"; do
    echo "  chezmoi apply $path"
    chezmoi apply "$path" 2>/dev/null || true
  done
fi

echo ""
if [ "$INSTALLED" -gt 0 ]; then
  echo "Done! Software installed and configs applied."
  echo ""
  echo "To apply all configs:  chezmoi apply"
  echo "To re-run installer:   $(chezmoi source-path)/install.sh"
else
  echo "Nothing selected. Run this script again to install components."
fi
