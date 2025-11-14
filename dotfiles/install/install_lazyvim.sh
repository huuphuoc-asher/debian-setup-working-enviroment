#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "📦 Installing LazyVim + TokyoNight config..."

# Clone LazyVim starter if not present
if [ ! -d "$HOME/.config/nvim" ]; then
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
fi

# Copy our overrides
mkdir -p "$HOME/.config/nvim/lua/config"
mkdir -p "$HOME/.config/nvim/lua/plugins"

cp "$DOTFILES_DIR/config/nvim/lua/config/options.lua" "$HOME/.config/nvim/lua/config/options.lua"
cp "$DOTFILES_DIR/config/nvim/lua/plugins/tokyonight.lua" "$HOME/.config/nvim/lua/plugins/tokyonight.lua"

echo "✅ LazyVim TokyoNight theme installed."
