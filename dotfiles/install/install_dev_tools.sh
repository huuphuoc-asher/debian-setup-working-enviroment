#!/usr/bin/env bash
set -e

echo "======================================"
echo " 🧰 Installing dev tools (Debian)"
echo "======================================"

sudo apt update
sudo apt install -y \
  curl wget git ca-certificates gnupg lsb-release apt-transport-https \
  software-properties-common build-essential unzip

# --------------------------------------
# Google Chrome
# --------------------------------------
echo "🌐 Installing Google Chrome..."
if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then
  wget -q -O- https://dl.google.com/linux/linux_signing_key.pub |
    sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" |
    sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
fi
sudo apt update
sudo apt install -y google-chrome-stable

# --------------------------------------
# Visual Studio Code
# --------------------------------------
echo "💻 Installing VS Code..."
if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >/tmp/packages.microsoft.gpg
  sudo install -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f /tmp/packages.microsoft.gpg
fi
sudo apt update
sudo apt install -y code

# --------------------------------------
# Neovim, tmux, make (core CLI tools)
# --------------------------------------
echo "🧠 Installing Neovim, tmux, make..."
sudo apt install -y neovim tmux make

# --------------------------------------
# Postman (tarball to /opt)
# --------------------------------------
echo "📮 Installing Postman..."
if [ ! -d /opt/Postman ]; then
  wget https://dl.pstmn.io/download/latest/linux64 -O /tmp/postman-linux.tar.gz
  sudo tar -xzf /tmp/postman-linux.tar.gz -C /opt
  sudo ln -sf /opt/Postman/Postman /usr/bin/postman
  rm /tmp/postman-linux.tar.gz
fi

# --------------------------------------
# Docker Engine + Compose + Docker Desktop
# --------------------------------------
echo "🐳 Installing Docker Engine + Compose plugin..."
sudo apt remove -y docker docker-engine docker.io containerd runc || true

sudo install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/debian/gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "🐳 Installing Docker Desktop..."
if ! dpkg -s docker-desktop >/dev/null 2>&1; then
  wget https://desktop.docker.com/linux/main/amd64/docker-desktop.deb -O /tmp/docker-desktop.deb
  sudo apt install -y /tmp/docker-desktop.deb || sudo apt -f install -y
  rm /tmp/docker-desktop.deb
fi

sudo usermod -aG docker "$USER"

# --------------------------------------
# Node.js stack (nvm + node + npm + yarn + pnpm)
# --------------------------------------
echo "📦 Installing nvm + Node.js LTS + npm + yarn + pnpm..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
fi

# load nvm in this script context
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm alias default 'lts/*'
npm install -g yarn pnpm

# --------------------------------------
# zoxide
# --------------------------------------
echo "🧭 Installing zoxide..."
if ! command -v zoxide >/dev/null 2>&1; then
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# --------------------------------------
# lazygit
# --------------------------------------
echo "📟 Installing lazygit..."
if ! command -v lazygit >/dev/null 2>&1; then
  LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest |
    grep -Po '"tag_name": "\K.*?(?=")')
  wget -q "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" \
    -O /tmp/lazygit.tar.gz
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin/lazygit
  rm /tmp/lazygit /tmp/lazygit.tar.gz
fi

# --------------------------------------
# neofetch
# --------------------------------------
echo "📊 Installing neofetch..."
sudo apt install -y neofetch

# --------------------------------------
# kubectl
# --------------------------------------
echo "🐙 Installing kubectl..."
if ! command -v kubectl >/dev/null 2>&1; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  rm kubectl
fi

# --------------------------------------
# kind
# --------------------------------------
echo "🛳️ Installing kind..."
if ! command -v kind >/dev/null 2>&1; then
  curl -Lo /tmp/kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
  sudo install -o root -g root -m 0755 /tmp/kind /usr/local/bin/kind
  rm /tmp/kind
fi

# --------------------------------------
# Cleanup
# --------------------------------------
echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "✅ Dev tools installed."
echo "👉 Log out / log in to apply Docker group changes for user: $USER"
