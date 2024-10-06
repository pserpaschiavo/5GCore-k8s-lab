!# /bin/bash

wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
tar -C /usr/local -zxvf go1.14.4.linux-amd64.tar.gz
mkdir -p home/vagrant/go/{bin,pkg,src}
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin:$GOROOT/bin' >> ~/.bashrc
source ~/.bashrc


git clone https://github.com/my5G/my5G-RANTester.git

cd /home/vagrant/my5G-RANTester
go mod download

cd /home/vagrant/my5G-RANTester/cmd
go build app.go