#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y gcc make vim tmux git curl iproute2 iputils-ping iperf3 tcpdump python3-pip


wget https://github.com/free5gc/gtp5g/archive/refs/tags/v0.9.0.tar.gz
tar -zxvf v0.9.0.tar.gz

cd gtp5g-0.9.0

make clean && make
sudo make install