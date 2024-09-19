#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y gcc make

git clone https://github.com/free5gc/gtp5g.git && cd gtp5g
make clean && make
sudo make install