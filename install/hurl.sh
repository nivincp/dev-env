#!/usr/bin/env bash
set -e

curl -fsSL \
  https://github.com/Orange-OpenSource/hurl/releases/download/7.1.0/hurl-7.1.0-aarch64-unknown-linux-gnu.tar.gz \
  -o /tmp/hurl.tgz

tar -xzf /tmp/hurl.tgz -C /tmp
sudo mv /tmp/hurl-7.1.0-aarch64-unknown-linux-gnu/bin/hurl /usr/local/bin/hurl
sudo chmod +x /usr/local/bin/hurl

hurl --version
