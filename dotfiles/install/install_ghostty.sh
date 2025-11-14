#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🖥️ Setting up Ghostty config..."

mkdir -p "$HOME/.config/ghostty"
cp "$DOTFILES_DIR/config/ghostty/config" "$HOME/.config/ghostty/config"

echo "✅ Ghostty TokyoNight config installed."
