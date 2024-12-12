#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run the script as root (sudo)."
  exit 1
fi

read -p "Enter your Prover ID: " PROVER_ID
if [ -z "$PROVER_ID" ]; then
  echo "Prover ID cannot be empty."
  exit 1
fi

sudo apt update && sudo apt upgrade -y

sudo apt install -y build-essential pkg-config libssl-dev git-all
sudo apt install -y protobuf-compiler
sudo apt install -y cargo

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

rustup update

mkdir -p ~/.nexus
echo "$PROVER_ID" > ~/.nexus/prover-id

sudo apt install -y screen

screen -dmS nexus bash -c 'curl https://cli.nexus.xyz/ | sh'
