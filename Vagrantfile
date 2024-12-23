# Define a single VM configuration
VM_CONFIG = {
  name: "Vagrant-TestVM", # Updated definition name
  box: "bento/ubuntu-22.04",
  ip: "192.168.1.95",
  hostname: "vldocsrv095.nanitech",
  vm_name: "Vagrant-VLDOCSRV095", # The VirtualBox VM name remains the same
  memory: 4096,
  cpus: 2,
  vram: 16,
  description: "IP: 192.168.1.95"
}

Vagrant.configure("2") do |config|
  # Configure the VM using the VM_CONFIG hash
  config.vm.define VM_CONFIG[:name] do |server|
    server.vm.box = VM_CONFIG[:box]
    server.vm.network "public_network", ip: VM_CONFIG[:ip]
    server.vm.hostname = VM_CONFIG[:hostname]
    server.vm.provider "virtualbox" do |vb|
      vb.name = VM_CONFIG[:vm_name] # This is the VirtualBox VM name
      vb.memory = VM_CONFIG[:memory]
      vb.cpus = VM_CONFIG[:cpus]
      vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
      vb.customize ["modifyvm", :id, "--vram", VM_CONFIG[:vram]]
      vb.customize [
        "modifyvm", :id,
        "--boot1", "dvd",
        "--boot2", "disk"
      ]
      vb.customize ["modifyvm", :id, "--description", VM_CONFIG[:description]]
    end
    # Provisioning scripts
    server.vm.provision "shell", path: "scripts/update.sh"
    server.vm.provision "shell", path: "scripts/create_user.sh"
    server.vm.provision "shell", path: "scripts/docker.sh"
  end
end
