#!/bin/sh

# set error
set -e

# move to a homedir
mkdir "$HOME/start9" && cd "$HOME/start9" && pwd

# Start9 SDK
git clone --recursive https://github.com/Start9Labs/start-os.git --branch sdk
cd start-os/
make sdk
start-sdk init