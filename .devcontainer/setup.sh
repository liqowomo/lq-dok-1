#!/usr/bin/env bash

set -euxo pipefail

echo "🚀 Starting minimal dev setup..."

# ----------------------
# Install Dependencies
# ----------------------
sudo apt update && sudo apt install -y \
  curl \
  wget \
  git \
  gnupg \
  build-essential \
  software-properties-common \
  libssl-dev \
  lsb-release \
  procps \
  xclip

# ----------------------
# Install Latest Python (3.12)
# ----------------------
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.12 python3-pip

# ----------------------
# Install Latest Go (1.23.x)
# ----------------------
GO_VERSION="1.23.0"
wget --quiet https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

cat <<'EOF' >> ~/.bashrc
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
EOF

rm go${GO_VERSION}.linux-amd64.tar.gz

# ----------------------
# Install Rust + Cargo
# ----------------------
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

source "$HOME/.cargo/env"

# ----------------------
# Install Node.js via fnm
# ----------------------
curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm"

export PATH="$HOME/.fnm:$PATH"
eval "$(fnm env)"

fnm install --lts

# ----------------------
# Install PNPM via Corepack
# ----------------------
corepack enable
corepack prepare pnpm@latest --activate

# ----------------------
# Install Fish Shell v4 PPA and Fish 4.x
# ----------------------
sudo apt install -y software-properties-common
sudo apt-add-repository ppa:fish-shell/release-4 -y
sudo apt update
sudo apt install -y fish

# ----------------------
# Done!
# ----------------------
echo "✅ Setup complete! All tools installed."
echo "🎉 You now have:"
echo " - Python 3.12"
echo " - Go 1.23"
echo " - Rust (latest stable)"
echo " - Fish Shell v4"
echo " - Homebrew"
echo " - Node.js (LTS via fnm)"
echo " - PNPM package manager"
