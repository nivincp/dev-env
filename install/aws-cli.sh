#!/usr/bin/env bash
set -e

curl -fsSL \
  https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip \
  -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp
sudo /tmp/aws/install

aws --version
