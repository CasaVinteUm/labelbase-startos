#!/bin/sh

# set error
set -e

# Move to a tempdir
cd "$(mktemp -d)"

# Hardcoded to yq 4.43.1
curl -LO https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_amd64.tar.gz

# Check the checksum
echo "049d1f3791cc25160a71b0bbe14a58302fb6a7e4462e07d5cbd543787a9ad815  yq_linux_amd64.tar.gz" | sha256sum -c -

# untar
tar -xzf yq_linux_amd64.tar.gz
sudo mv yq_linux_amd64 /usr/bin/yq

# remove everything
rm -rf -- *

# test command
yq --version