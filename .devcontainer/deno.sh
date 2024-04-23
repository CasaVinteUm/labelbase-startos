#!/bin/sh

# set error
set -e

# Move to a tempdir
cd "$(mktemp -d)"

# Hardcoded to deno 1.42.4
curl -LO https://github.com/denoland/deno/releases/download/v1.42.4/deno-x86_64-unknown-linux-gnu.zip

# Check the checksum
echo "8f769ded5ec44511ee8410c6389174e79c9d142cb4e47385d7358b552c63bdb9 deno-x86_64-unknown-linux-gnu.zip" | sha256sum -c -

# unzip
unzip deno-x86_64-unknown-linux-gnu.zip
sudo mv deno /usr/bin/deno

# remove everything
rm -rf -- *

# test command
deno --version