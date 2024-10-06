Vagrant.configure("2") do |config|
    (1..1).each do |i|
        config.vm.define "master-#{i}" do |k8s|
            k8s.vm.box = "ubuntu/focal64"
            # k8s.vm.box = "ubuntu/jammy64"
            # k8s.vm.box = "rockylinux/9"
            k8s.vm.hostname = "master-#{i}"
            k8s.vm.network "private_network", ip: "172.89.0.1#{i}"

            k8s.ssh.insert_key = false
            k8s.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
            k8s.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

            k8s.vm.synced_folder "./.cluster-join", "/tmp/.cluster-join"
            k8s.vm.synced_folder "~/.kube", "/mnt/.kube"


            # k8s.vm.provision :shell, privileged: true, :path => "setup-vm/gtp5g-kernel-module.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/container_runtime.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/kubeadm-master.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/setIP.sh"

            k8s.vm.provider "virtualbox" do |vb|
              vb.gui = false
              vb.cpus = 2
              vb.memory = "8192"  

            end
        end
    end

    (1..1).each do |i|
        config.vm.define "worker-#{i}" do |k8s|
            k8s.vm.box = "ubuntu/focal64"
            # k8s.vm.box = "ubuntu/jammy64"
            # k8s.vm.box = "rockylinux/9"
            k8s.vm.hostname = "worker-#{i}"
            k8s.vm.network "private_network", ip: "172.89.0.2#{i}"

            k8s.ssh.insert_key = false
            k8s.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
            k8s.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

            k8s.vm.synced_folder "./.cluster-join", "/tmp/.cluster-join"

            k8s.vm.provision "shell", inline: <<-SHELL
                mkdir -p /home/vagrant/kubedata
            SHELL
            
            # k8s.vm.provision :shell, privileged: true, :path => "setup-vm/gtp5g-kernel-module.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/container_runtime.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/kubeadm-worker.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/setIP.sh"

            k8s.vm.provider "virtualbox" do |vb|
              vb.gui = false
              vb.cpus = 2
              vb.memory = "8192"
            
            end
        end
    end

    (1..1).each do |i|
        config.vm.define "tester-#{i}" do |k8s|
            k8s.vm.box = "ubuntu/focal64"
            # k8s.vm.box = "ubuntu/jammy64"
            # k8s.vm.box = "rockylinux/9"
            k8s.vm.hostname = "tester-#{i}"
            k8s.vm.network "private_network", ip: "172.89.0.3#{i}"

            k8s.ssh.insert_key = false
            k8s.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa']
            k8s.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"

            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/container_runtime.sh"
            k8s.vm.provision :shell, privileged: true, :path => "setup-vm/my5gRANTester.sh"

            k8s.vm.provider "virtualbox" do |vb|
              vb.gui = false
              vb.cpus = 2
              vb.memory = "4096"
            
            end
        end
    end


end