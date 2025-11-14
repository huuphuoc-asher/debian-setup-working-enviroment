#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 Using dotfiles dir: $DOTFILES_DIR"

chmod +x "$DOTFILES_DIR"/install/*.sh

"$DOTFILES_DIR"/install/install_dev_tools.sh
"$DOTFILES_DIR"/install/install_shell.sh
"$DOTFILES_DIR"/install/install_tmux.sh
"$DOTFILES_DIR"/install/install_ghostty.sh
"$DOTFILES_DIR"/install/install_lazyvim.sh

echo "✅ All configs and dev tools installed. Restart your terminal/session."
