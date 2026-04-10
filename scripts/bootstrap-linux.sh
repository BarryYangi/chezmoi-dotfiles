#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"
DRY_RUN="${DRY_RUN:-false}"
PACKAGE_MANAGER=""
PACKAGE_INDEX_REFRESHED=false
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

run_root_cmd() {
  if [ "$DRY_RUN" = "true" ]; then
    printf "+"
    if [ "$(id -u)" -ne 0 ]; then
      printf " %q" sudo
    fi
    printf " %q" "$@"
    printf "\n"
    return 0
  fi

  if [ "$(id -u)" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

detect_sys_pm() {
  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
  elif command -v dnf >/dev/null 2>&1; then
    echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then
    echo "pacman"
  elif command -v zypper >/dev/null 2>&1; then
    echo "zypper"
  elif command -v apk >/dev/null 2>&1; then
    echo "apk"
  else
    echo "unknown"
  fi
}

refresh_package_index() {
  if [ "$PACKAGE_INDEX_REFRESHED" = true ]; then
    return 0
  fi

  case "$PACKAGE_MANAGER" in
    apt)
      log "Refreshing apt package index..."
      run_root_cmd apt-get update
      ;;
    dnf)
      log "Refreshing dnf metadata..."
      run_root_cmd dnf makecache
      ;;
    zypper)
      log "Refreshing zypper metadata..."
      run_root_cmd zypper refresh
      ;;
  esac

  PACKAGE_INDEX_REFRESHED=true
}

resolve_linux_pkg() {
  local pkg="$1"

  case "$PACKAGE_MANAGER:$pkg" in
    apt:chezmoi)
      echo ""
      ;;
    apt:exiftool)
      echo "libimage-exiftool-perl"
      ;;
    dnf:exiftool|zypper:exiftool)
      echo "perl-Image-ExifTool"
      ;;
    pacman:exiftool)
      echo "perl-image-exiftool"
      ;;
    *)
      echo "$pkg"
      ;;
  esac
}

install_pkg() {
  local requested_pkg="$1"
  local pkg=""

  pkg="$(resolve_linux_pkg "$requested_pkg")"
  if [ -z "$pkg" ]; then
    warn "$requested_pkg is not available from $PACKAGE_MANAGER. Install it manually if needed."
    return 0
  fi

  refresh_package_index
  log "Installing $requested_pkg..."

  case "$PACKAGE_MANAGER" in
    apt)
      if ! run_root_cmd apt-get install -y "$pkg"; then
        warn "Failed to install $requested_pkg with apt."
      fi
      ;;
    dnf)
      if ! run_root_cmd dnf install -y "$pkg"; then
        warn "Failed to install $requested_pkg with dnf."
      fi
      ;;
    pacman)
      if ! run_root_cmd pacman -S --noconfirm "$pkg"; then
        warn "Failed to install $requested_pkg with pacman."
      fi
      ;;
    zypper)
      if ! run_root_cmd zypper install -y "$pkg"; then
        warn "Failed to install $requested_pkg with zypper."
      fi
      ;;
    apk)
      if ! run_root_cmd apk add "$pkg"; then
        warn "Failed to install $requested_pkg with apk."
      fi
      ;;
  esac
}

ensure_chezmoi() {
  if command -v chezmoi >/dev/null 2>&1; then
    return 0
  fi

  log "Installing chezmoi..."
  if [ "$PACKAGE_MANAGER" = "apt" ]; then
    if ! run_shell "sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- -b \"$HOME/.local/bin\""; then
      warn "Failed to install chezmoi with the official installer."
    fi
    export PATH="$HOME/.local/bin:$PATH"
  else
    install_pkg chezmoi
  fi
}

install_maple_mono_fonts() {
  local tmp_dir=""
  local fonts_dir="$HOME/.local/share/fonts/maple-mono"
  local nf_zip=""
  local nf_cn_zip=""

  install_pkg unzip
  install_pkg fontconfig

  if ! command -v unzip >/dev/null 2>&1; then
    warn "unzip is missing, skipping Maple Mono font installation."
    return 0
  fi

  tmp_dir="$(mktemp -d)"
  nf_zip="$tmp_dir/MapleMono-NF.zip"
  nf_cn_zip="$tmp_dir/MapleMono-NF-CN.zip"

  log "Installing Maple Mono fonts..."
  run_cmd mkdir -p "$fonts_dir"

  if run_cmd curl -fsSL -o "$nf_zip" https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-unhinted.zip &&
    run_cmd unzip -oq "$nf_zip" -d "$tmp_dir/nf"; then
    run_shell "find \"$tmp_dir/nf\" -type f \\( -name '*.ttf' -o -name '*.otf' \\) -exec cp {} \"$fonts_dir\" \\;"
  else
    warn "Failed to install Maple Mono NF."
  fi

  if run_cmd curl -fsSL -o "$nf_cn_zip" https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono-NF-CN-unhinted.zip &&
    run_cmd unzip -oq "$nf_cn_zip" -d "$tmp_dir/nf-cn"; then
    run_shell "find \"$tmp_dir/nf-cn\" -type f \\( -name '*.ttf' -o -name '*.otf' \\) -exec cp {} \"$fonts_dir\" \\;"
  else
    warn "Failed to install Maple Mono NF CN."
  fi

  if command -v fc-cache >/dev/null 2>&1; then
    run_cmd fc-cache -f "$HOME/.local/share/fonts"
  else
    warn "fc-cache is missing, so the new fonts may not be visible until font cache is rebuilt."
  fi

  run_cmd rm -rf "$tmp_dir"
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
  log "==> bootstrap-linux"

  PACKAGE_MANAGER="$(detect_sys_pm)"
  if [ "$PACKAGE_MANAGER" = "unknown" ]; then
    log "No supported Linux package manager found."
    exit 1
  fi

  for cmd in curl git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      log "$cmd is required but not found."
      exit 1
    fi
  done

  ensure_chezmoi
  install_pkg zsh
  install_pkg gh
  install_pkg hub
  install_pkg fzf
  install_pkg zoxide
  install_pkg eza
  install_pkg diff-so-fancy
  install_pkg neovim
  install_pkg yazi
  install_pkg zellij
  install_pkg fastfetch
  install_pkg btop
  install_pkg mpv
  install_pkg mediainfo
  install_pkg unar
  install_pkg exiftool
  install_maple_mono_fonts
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
