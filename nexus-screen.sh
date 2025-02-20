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

sudo apt install -y build-essential pkg-config libssl-dev unzip curl screen git-all
sudo apt install -y protobuf-compiler
sudo apt install -y cargo

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

rustup update

sudo apt remove -y protobuf-compiler
curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v25.2/protoc-25.2-linux-x86_64.zip
unzip protoc-25.2-linux-x86_64.zip -d $HOME/.local
export PATH="$HOME/.local/bin:$PATH"

sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

mkdir -p ~/.nexus
echo "$PROVER_ID" > ~/.nexus/node-id

curl https://cli.nexus.xyz/ | sh
