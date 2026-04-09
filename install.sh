#!/bin/bash

set -e

# ============================================
# OS Detection
# ============================================
OS="$(uname -s)"
DISTRO=""

if [ "$OS" = "Linux" ]; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
  fi
fi

# ============================================
# Install helpers
# ============================================
install_pkg() {
  local pkg="$1"
  echo "  Installing $pkg..."
  if [ "$OS" = "Darwin" ]; then
    brew install "$pkg" 2>/dev/null || true
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y "$pkg" 2>/dev/null || true
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y "$pkg" 2>/dev/null || true
  elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm "$pkg" 2>/dev/null || true
  else
    echo "  ⚠ No supported package manager found, skipping $pkg"
  fi
}

install_cask() {
  local pkg="$1"
  if [ "$OS" = "Darwin" ]; then
    echo "  brew install --cask $pkg"
    brew install --cask "$pkg" 2>/dev/null || true
  fi
  # Linux GUI apps handled in do_install with platform-specific methods
}

install_from_url() {
  local name="$1" url="$2"
  echo "  Installing $name from release..."
  curl -fsSL "$url" | bash 2>/dev/null || true
}

# ============================================
# Interactive multi-select menu
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

declare -A HEADERS
HEADERS[0]="── Shell ──────────────────────────────────────────"
HEADERS[6]="── Terminal Emulators ─────────────────────────────"
HEADERS[9]="── Editors ────────────────────────────────────────"
HEADERS[13]="── CLI Tools ──────────────────────────────────────"
HEADERS[17]="── Runtime ────────────────────────────────────────"

count_lines() {
  local lines=$((TOTAL + 3))
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
  echo "  Dotfiles Installer ($OS)"
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
# Oh My Zsh installer
# ============================================
install_omz() {
  # Ensure zsh is installed on Linux
  if [ "$OS" = "Linux" ] && ! command -v zsh &>/dev/null; then
    echo "  Installing zsh..."
    install_pkg zsh
  fi

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

# ============================================
# Map index -> install command (OS-aware)
# ============================================
do_install() {
  local i=$1
  case $i in
    0) install_omz ;;
    1) # eza
      if [ "$OS" = "Darwin" ]; then
        brew install eza 2>/dev/null || true
      else
        install_pkg eza
      fi
      ;;
    2) # zoxide
      if [ "$OS" = "Darwin" ]; then
        brew install zoxide 2>/dev/null || true
      else
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh 2>/dev/null || install_pkg zoxide
      fi
      ;;
    3) # fzf
      if [ "$OS" = "Darwin" ]; then
        brew install fzf 2>/dev/null || true
      else
        install_pkg fzf
      fi
      ;;
    4) # hub
      if [ "$OS" = "Darwin" ]; then
        brew install hub 2>/dev/null || true
      else
        install_pkg hub
      fi
      ;;
    5) # diff-so-fancy
      if [ "$OS" = "Darwin" ]; then
        brew install diff-so-fancy 2>/dev/null || true
      else
        install_pkg diff-so-fancy
      fi
      ;;
    6) # Ghostty
      if [ "$OS" = "Darwin" ]; then
        brew install --cask ghostty 2>/dev/null || true
      else
        echo "  Ghostty: Install from https://ghostty.org/download"
        install_pkg ghostty 2>/dev/null || true
      fi
      ;;
    7) # Kitty
      if [ "$OS" = "Darwin" ]; then
        brew install --cask kitty 2>/dev/null || true
      else
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin 2>/dev/null || install_pkg kitty
      fi
      ;;
    8) # WezTerm
      if [ "$OS" = "Darwin" ]; then
        brew install --cask wezterm 2>/dev/null || true
      else
        install_pkg wezterm 2>/dev/null || echo "  WezTerm: Install from https://wezfurlong.org/wezterm/install/linux.html"
      fi
      ;;
    9) # Neovim
      if [ "$OS" = "Darwin" ]; then
        brew install neovim 2>/dev/null || true
      else
        install_pkg neovim
      fi
      ;;
    10) # Zed
      if [ "$OS" = "Darwin" ]; then
        brew install --cask zed 2>/dev/null || true
      else
        curl -f https://zed.dev/install.sh | sh 2>/dev/null || true
      fi
      ;;
    11) # VS Code
      if [ "$OS" = "Darwin" ]; then
        brew install --cask visual-studio-code 2>/dev/null || true
      else
        install_pkg code 2>/dev/null || echo "  VS Code: Install from https://code.visualstudio.com/download"
      fi
      ;;
    12) # Cursor
      if [ "$OS" = "Darwin" ]; then
        brew install --cask cursor 2>/dev/null || true
      else
        echo "  Cursor: Install from https://www.cursor.com/downloads"
      fi
      ;;
    13) # Yazi
      if [ "$OS" = "Darwin" ]; then
        brew install yazi 2>/dev/null || true
      else
        cargo install --locked yazi-fm yazi-cli 2>/dev/null || install_pkg yazi
      fi
      ;;
    14) # Zellij
      if [ "$OS" = "Darwin" ]; then
        brew install zellij 2>/dev/null || true
      else
        cargo install --locked zellij 2>/dev/null || install_pkg zellij
      fi
      ;;
    15) # Fastfetch
      if [ "$OS" = "Darwin" ]; then
        brew install fastfetch 2>/dev/null || true
      else
        install_pkg fastfetch
      fi
      ;;
    16) # Btop
      if [ "$OS" = "Darwin" ]; then
        brew install btop 2>/dev/null || true
      else
        install_pkg btop
      fi
      ;;
    17) # nvm
      if [ "$OS" = "Darwin" ]; then
        brew install nvm 2>/dev/null || true
      else
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash 2>/dev/null || true
      fi
      ;;
    18) # Bun
      if [ "$OS" = "Darwin" ]; then
        brew install bun 2>/dev/null || true
      else
        curl -fsSL https://bun.sh/install | bash 2>/dev/null || true
      fi
      ;;
  esac
}

# ============================================
# Map index -> chezmoi config paths (OS-aware)
# ============================================
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
    11) # VS Code
      if [ "$OS" = "Darwin" ]; then
        echo "$HOME/Library/Application Support/Code/User/settings.json"
      else
        echo "$HOME/.config/Code/User/settings.json"
      fi
      ;;
    12) # Cursor
      if [ "$OS" = "Darwin" ]; then
        echo "$HOME/Library/Application Support/Cursor/User/settings.json"
      else
        echo "$HOME/.config/Cursor/User/settings.json"
      fi
      ;;
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

# Ensure Homebrew on macOS
if [ "$OS" = "Darwin" ]; then
  if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# Ensure basic tools on Linux
if [ "$OS" = "Linux" ]; then
  for cmd in curl git; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Installing $cmd..."
      install_pkg "$cmd"
    fi
  done
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

    path=$(get_config_paths "$i")
    [ -n "$path" ] && CONFIG_PATHS+=("$path")
  fi
done

# Apply configs
if [ ${#CONFIG_PATHS[@]} -gt 0 ]; then
  echo ""
  echo "Applying configs..."
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
  echo "To re-run installer:   \$(chezmoi source-path)/install.sh"
else
  echo "Nothing selected. Run this script again to install components."
fi
