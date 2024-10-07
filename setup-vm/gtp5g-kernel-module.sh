#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y gcc make vim tmux git curl iproute2 iputils-ping iperf3 tcpdump python3-pip openvswitch-switch

git clone -b v0.6.6 https://github.com/free5gc/gtp5g.git
cd gtp5g
make
sudo make install

# sudo ovs-vsctl --may-exist add-br n2br
# sudo ovs-vsctl --may-exist add-br n3br
# sudo ovs-vsctl --may-exist add-br n4br
