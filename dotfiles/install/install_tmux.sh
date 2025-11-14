#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "📦 Installing tmux + theme..."

sudo apt install -y tmux

mkdir -p "$HOME/.config/tmux"
cp "$DOTFILES_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

echo "source-file ~/.config/tmux/tmux.conf" >"$HOME/.tmux.conf"

echo "✅ Tmux TokyoNight theme installed. Restart tmux."
