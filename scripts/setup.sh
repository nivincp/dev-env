#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Helpers
# ----------------------------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_arm64() {
  if [[ "$(uname -m)" != "aarch64" && "$(uname -m)" != "arm64" ]]; then
    echo "✗ This script is intended for Linux ARM64 only"
    exit 1
  fi
}

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

# ----------------------------
# Platform check
# ----------------------------
require_arm64

# ----------------------------
# Prerequisites (asdf-compatible)
# ----------------------------
REQUIRED_PKGS=(
  git
  bash
  curl
  unzip
  ca-certificates
  gnupg
  file
)

MISSING_PKGS=()
for pkg in "${REQUIRED_PKGS[@]}"; do
  dpkg -s "$pkg" >/dev/null 2>&1 || MISSING_PKGS+=("$pkg")
done

if (( ${#MISSING_PKGS[@]} > 0 )); then
  sudo apt-get update
  sudo apt-get install -y "${MISSING_PKGS[@]}"
  sudo apt-get clean
fi

# ----------------------------
# Install asdf
# ----------------------------
ASDF_VERSION="v0.14.1"
ASDF_DIR="$HOME/.asdf"

if [[ -d "$ASDF_DIR" ]]; then
  echo "✓ asdf already installed"
else
  echo "→ Installing asdf ${ASDF_VERSION}"
  git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR" --branch "$ASDF_VERSION"
fi

# Activate asdf for this script
# shellcheck disable=SC1090
. "$ASDF_DIR/asdf.sh"

# Persist activation (zsh is primary shell)
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  if [[ -f "$rc" ]] && ! grep -q 'asdf.sh' "$rc"; then
    echo '. "$HOME/.asdf/asdf.sh"' >> "$rc"
  fi
done

asdf --version

# ----------------------------
# Install Node.js (latest LTS via asdf)
# ----------------------------
if asdf plugin list | grep -q '^nodejs$'; then
  asdf plugin update nodejs
else
  asdf plugin add nodejs
fi

# Handle old vs new plugin keyring logic safely
KEYRING_SCRIPT="$ASDF_DIR/plugins/nodejs/bin/import-release-team-keyring"
if [[ -x "$KEYRING_SCRIPT" ]]; then
  bash "$KEYRING_SCRIPT"
else
  echo "→ Node.js keyring helper not present (new plugin version, continuing)"
fi

if asdf list nodejs | grep -q 'lts'; then
  echo "✓ Node.js LTS already installed"
else
  echo "→ Installing Node.js (LTS)"
  asdf install nodejs lts
fi

asdf global nodejs lts
asdf reshim nodejs

node -v
npm -v

# ----------------------------
# Install Hurl (Linux ARM64)
# ----------------------------
HURL_VERSION="7.1.0"
HURL_ARCH="aarch64-unknown-linux-gnu"

if command_exists hurl; then
  echo "✓ Hurl already installed: $(hurl --version)"
else
  echo "→ Installing Hurl ${HURL_VERSION}"
  curl -fsSL \
    "https://github.com/Orange-OpenSource/hurl/releases/download/${HURL_VERSION}/hurl-${HURL_VERSION}-${HURL_ARCH}.tar.gz" \
    -o "$TMP_DIR/hurl.tgz"

  tar -xzf "$TMP_DIR/hurl.tgz" -C "$TMP_DIR"
  sudo mv "$TMP_DIR/hurl-${HURL_VERSION}-${HURL_ARCH}/bin/hurl" /usr/local/bin/hurl
  sudo chmod +x /usr/local/bin/hurl

  hurl --version
fi

# ----------------------------
# Install AWS CLI v2 (Linux ARM64)
# ----------------------------
if command_exists aws; then
  echo "✓ AWS CLI already installed: $(aws --version)"
else
  echo "→ Installing AWS CLI v2"
  curl -fsSL \
    "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" \
    -o "$TMP_DIR/awscliv2.zip"

  unzip -q "$TMP_DIR/awscliv2.zip" -d "$TMP_DIR"
  sudo "$TMP_DIR/aws/install"

  aws --version
fi

# ----------------------------
# Install Terraform (Linux ARM64)
# ----------------------------
TERRAFORM_VERSION="1.5.5"

if command_exists terraform; then
  echo "✓ Terraform already installed: $(terraform version | head -n 1)"
else
  echo "→ Installing Terraform ${TERRAFORM_VERSION}"
  curl -fsSL \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip" \
    -o "$TMP_DIR/terraform.zip"

  unzip -q "$TMP_DIR/terraform.zip" -d "$TMP_DIR"
  sudo mv "$TMP_DIR/terraform" /usr/local/bin/terraform
  sudo chmod +x /usr/local/bin/terraform

  terraform version
fi

# ----------------------------
# Install Vercel CLI
# ----------------------------
if command_exists vercel; then
  echo "✓ Vercel CLI already installed: $(vercel --version)"
else
  echo "→ Installing Vercel CLI"
  npm install -g vercel@latest
  vercel --version
fi