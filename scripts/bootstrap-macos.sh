#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"
DRY_RUN="${DRY_RUN:-false}"
WARNINGS=()

log() {
  echo "$1"
}

warn() {
  local message="$1"
  log "WARNING: $message"
  WARNINGS+=("$message")
}

run_cmd() {
  if [ "$DRY_RUN" = "true" ]; then
    printf "+"
    printf " %q" "$@"
    printf "\n"
    return 0
  fi

  "$@"
}

run_shell() {
  local command="$1"

  if [ "$DRY_RUN" = "true" ]; then
    printf "+ sh -c %q\n" "$command"
    return 0
  fi

  sh -c "$command"
}

ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  log "Installing Homebrew..."
  run_shell "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""

  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    warn "Homebrew installation completed but brew was not found in a standard location."
  fi
}

brew_install_formula() {
  local package="$1"

  log "Installing $package..."
  if ! run_cmd brew install "$package"; then
    warn "Failed to install $package."
  fi
}

brew_install_cask() {
  local package="$1"

  log "Installing $package..."
  if ! run_cmd brew install --cask "$package"; then
    warn "Failed to install $package."
  fi
}

install_oh_my_zsh() {
  local zsh_custom=""

  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing oh-my-zsh..."
    if ! run_shell "RUNZSH=no CHSH=no sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""; then
      warn "Failed to install oh-my-zsh."
      return 0
    fi
  fi

  zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

  if [ ! -d "$zsh_custom/themes/spaceship-prompt" ]; then
    log "Installing spaceship-prompt..."
    if run_cmd git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "$zsh_custom/themes/spaceship-prompt"; then
      run_cmd ln -sf "$zsh_custom/themes/spaceship-prompt/spaceship.zsh-theme" "$zsh_custom/themes/spaceship.zsh-theme"
    else
      warn "Failed to install spaceship-prompt."
    fi
  fi

  if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
    log "Installing zsh-autosuggestions..."
    if ! run_cmd git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"; then
      warn "Failed to install zsh-autosuggestions."
    fi
  fi

  if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
    log "Installing zsh-syntax-highlighting..."
    if ! run_cmd git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_custom/plugins/zsh-syntax-highlighting"; then
      warn "Failed to install zsh-syntax-highlighting."
    fi
  fi
}

install_nvm() {
  if [ -d "$HOME/.nvm" ]; then
    return 0
  fi

  log "Installing nvm..."
  if ! run_shell "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash"; then
    warn "Failed to install nvm."
  fi
}

install_bun() {
  if command -v bun >/dev/null 2>&1; then
    return 0
  fi

  log "Installing bun..."
  if ! run_shell "curl -fsSL https://bun.sh/install | bash"; then
    warn "Failed to install bun."
  fi
}

ensure_chezmoi_source() {
  local current_source=""

  if current_source="$(chezmoi source-path 2>/dev/null)" && [ "$current_source" = "$REPO_DIR" ]; then
    return 0
  fi

  log "Initializing chezmoi with local source..."
  run_cmd chezmoi init --source="$REPO_DIR"
}

print_summary() {
  local warning=""

  echo ""
  log "Done."

  if [ ${#WARNINGS[@]} -gt 0 ]; then
    echo ""
    log "Warnings:"
    for warning in "${WARNINGS[@]}"; do
      log "  - $warning"
    done
  fi

  echo ""
  log "Manual extras still recommended:"
  log "  - Editors: Zed, VS Code, Cursor"
  log "  - Terminals: Ghostty, Kitty, WezTerm"
}

main() {
  log "==> bootstrap-macos"

  for cmd in curl git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log "$cmd is required but not found."
      exit 1
    fi
  done

  ensure_homebrew
  run_cmd brew tap homebrew/cask-fonts

  brew_install_formula chezmoi
  brew_install_formula zsh
  brew_install_formula gh
  brew_install_formula hub
  brew_install_formula fzf
  brew_install_formula zoxide
  brew_install_formula eza
  brew_install_formula diff-so-fancy
  brew_install_formula neovim
  brew_install_formula yazi
  brew_install_formula zellij
  brew_install_formula fastfetch
  brew_install_formula btop
  brew_install_formula mpv
  brew_install_formula mediainfo
  brew_install_formula unar
  brew_install_formula exiftool
  brew_install_cask font-maple-mono-nf
  brew_install_cask font-maple-mono-nf-cn

  install_oh_my_zsh
  install_nvm
  install_bun
  ensure_chezmoi_source

  log "Applying dotfiles..."
  if ! run_cmd chezmoi apply; then
    warn "chezmoi apply failed."
  fi

  print_summary
}

main "$@"
