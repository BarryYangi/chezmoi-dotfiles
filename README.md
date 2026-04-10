# dotfiles

My personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Quick Start

Install `chezmoi` using the recommended method for your platform, then initialize this repo and apply the files you want. This repo does not provide installer scripts. It mainly exists as a backup of my personal configuration.

```bash
chezmoi init BarryYangi/chezmoi-dotfiles
chezmoi apply
```

Works on both **macOS** and **Linux**.

### Dependencies

Install what is needed for the configs you actually plan to use:

- Shell: `zsh`, `oh-my-zsh`, `spaceship-prompt`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `gh`, `hub`, `fzf`, `zoxide`, `eza`, `diff-so-fancy`
- CLI tools: `nvim` (package name may be `neovim`), `yazi`, `zellij`, `fastfetch`, `btop`, `nvm`, `bun`
- Optional Yazi extras: `mpv`, `mediainfo`, `unar`, `exiftool`
- Fonts: `Maple Mono NF CN`, `Maple Mono NF`
- Manual GUI apps: `ghostty`, `kitty`, `wezterm`, `zed`, `visual-studio-code`, `cursor`

### Config Guide

- `zsh`: shell aliases, prompt, completions, and daily CLI workflow. Depends on `zsh`, `oh-my-zsh`, `spaceship-prompt`, `zsh-autosuggestions`, `zsh-syntax-highlighting`, `gh`, `hub`, `fzf`, `zoxide`, `eza`, `diff-so-fancy`, and optionally `nvm` and `bun`.
- `nvim`: editor config based on AstroNvim. Depends on the `nvim` command, which may be packaged as `neovim`.
- `yazi`: file manager config. Depends on `yazi`. `mpv`, `mediainfo`, `unar`, and `exiftool` are optional extras for opener and preview integrations.
- `zellij`: terminal multiplexer config. Depends on `zellij`.
- `fastfetch`: system info config. Depends on `fastfetch`.
- `btop`: system monitor config. Depends on `btop`.
- `ghostty`, `kitty`, `wezterm`: terminal emulator configs. Install the app manually first, then apply the matching config.
- `zed`, `visual-studio-code`, `cursor`: editor configs. Install the app manually first, then apply the matching config.

### Apply selectively

You can apply only specific configs:

```bash
chezmoi apply ~/.config/ghostty    # Ghostty only
chezmoi apply ~/.config/nvim       # nvim only
chezmoi apply ~/.zshrc             # zsh only
```

## What's Included

- Shell: zsh, aliases, prompt, completions
- Terminals: Ghostty, Kitty, WezTerm
- Editors: nvim, Zed, VS Code, Cursor
- CLI tools: Yazi, Zellij, Fastfetch, Btop
- Other: bun config, Claude Code instructions

## Supported Platforms

- **macOS** - Homebrew
- **Linux** - system package manager, primarily `apt` and `pacman`, with `dnf` / `zypper` / `apk` as best-effort fallbacks

This repo does not try to automate software installation. VS Code / Cursor config paths are automatically resolved per platform.

## Update

```bash
# Sync local changes to chezmoi
chezmoi re-add

# Push to remote
chezmoi cd && git add -A && git commit -m "update" && git push
```

## Agent Notes

If an agent is setting up this repo on a machine:

- Read this README first.
- Ask the user which config groups they actually want before installing anything.
- Detect the current platform.
- Choose the package manager based on platform.
- Install only the dependencies that are actually needed for the selected configs.
- If the user selects `zsh`, install the zsh-related dependencies first.
- After zsh dependencies are installed, make zsh the default login shell and continue the setup in a zsh session.
- Treat GUI apps like terminal emulators and GUI editors as manual installs.
