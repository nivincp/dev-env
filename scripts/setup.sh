#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Helpers
# ----------------------------
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# ----------------------------
# Prerequisites
# ----------------------------
if ! command_exists curl || ! command_exists unzip; then
  sudo apt-get update
  sudo apt-get install -y curl unzip ca-certificates
  sudo apt-get clean
fi

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
    -o /tmp/hurl.tgz

  tar -xzf /tmp/hurl.tgz -C /tmp
  sudo mv "/tmp/hurl-${HURL_VERSION}-${HURL_ARCH}/bin/hurl" /usr/local/bin/hurl
  sudo chmod +x /usr/local/bin/hurl
  rm -rf /tmp/hurl*

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
    -o /tmp/awscliv2.zip

  unzip -q /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip

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
    -o /tmp/terraform.zip

  unzip -q /tmp/terraform.zip -d /tmp
  sudo mv /tmp/terraform /usr/local/bin/terraform
  sudo chmod +x /usr/local/bin/terraform
  rm -rf /tmp/terraform.zip

  terraform version
fi