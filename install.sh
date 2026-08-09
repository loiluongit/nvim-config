#!/usr/bin/env bash
# Idempotent setup: skips anything already installed/linked, installs/fixes only what's missing.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG="$HOME/.config/nvim"

green() { printf '\033[32m%s\033[0m\n' "$1"; }
yellow() { printf '\033[33m%s\033[0m\n' "$1"; }
red() { printf '\033[31m%s\033[0m\n' "$1"; }

require_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    red "Homebrew not found. Install it from https://brew.sh, then re-run this script."
    exit 1
  fi
}

brew_ensure() {
  local formula="$1"
  if brew list --versions "$formula" >/dev/null 2>&1; then
    green "✓ $formula already installed"
  else
    yellow "→ installing $formula"
    brew install "$formula"
  fi
}

brew_cask_ensure() {
  local cask="$1"
  if brew list --cask --versions "$cask" >/dev/null 2>&1; then
    green "✓ $cask already installed"
  else
    yellow "→ installing $cask"
    brew install --cask "$cask"
  fi
}

link_config() {
  if [ -L "$NVIM_CONFIG" ] && [ "$(readlink "$NVIM_CONFIG")" = "$REPO_DIR" ]; then
    green "✓ ~/.config/nvim already linked to $REPO_DIR"
    return
  fi

  if [ -e "$NVIM_CONFIG" ] || [ -L "$NVIM_CONFIG" ]; then
    local backup
    backup="${NVIM_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
    yellow "→ existing ~/.config/nvim found, moving it to $backup"
    mv "$NVIM_CONFIG" "$backup"
  fi

  yellow "→ linking ~/.config/nvim -> $REPO_DIR"
  mkdir -p "$HOME/.config"
  ln -s "$REPO_DIR" "$NVIM_CONFIG"
  green "✓ linked"
}

sync_plugins() {
  yellow "→ syncing plugins (lazy.nvim + mason + treesitter)"
  nvim --headless "+Lazy! sync" +qa
  green "✓ plugins synced"
}

main() {
  require_brew

  brew_ensure neovim
  brew_ensure git
  brew_ensure ripgrep
  brew_cask_ensure font-jetbrains-mono-nerd-font

  link_config
  sync_plugins

  green "Done. Open nvim to start using it."
}

main "$@"
