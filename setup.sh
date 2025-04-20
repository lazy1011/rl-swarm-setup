#!/bin/bash

# Update and install packages
sudo apt update && sudo apt upgrade -y && sudo apt install -y \
curl git wget nano tmux htop nvme-cli lz4 jq make gcc clang build-essential \
autoconf automake pkg-config libssl-dev libleveldb-dev libgbm1 bsdmainutils \
ncdu unzip tar python3 python3-pip python3-venv python3-dev ca-certificates \
gnupg apt-transport-https screen

# Install Node.js and Yarn
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g yarn

# Remove conflicting Docker packages and install Docker
for p in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt remove -y $p; done
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Yarn setup
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install -y yarn

# Clone RL-Swarm repo and run setup
git clone https://github.com/gensyn-ai/rl-swarm && cd rl-swarm
screen -S rlswarm -dm bash -c 'python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh'
