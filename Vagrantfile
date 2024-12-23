VM_CONFIG = {
  name: ${definition_name},
  box: ${box},
  ip: ${ip},
  hostname: ${hostname},
  vm_name: ${vm_name},
  memory: ${memory},
  cpus: ${cpu},
  vram: ${vram},
  description: ${description}
}

Vagrant.configure("2") do |config|
  config.vm.define VM_CONFIG[:name] do |server|
    server.vm.box = VM_CONFIG[:box]
    server.vm.network "public_network", ip: VM_CONFIG[:ip]
    server.vm.hostname = VM_CONFIG[:hostname]
    server.vm.provider "virtualbox" do |vb|
      vb.name = VM_CONFIG[:vm_name]
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
    server.vm.provision "shell", path: "scripts/update.sh"
    server.vm.provision "shell", path: "scripts/create_user.sh"
    server.vm.provision "shell", path: "scripts/docker.sh"
  end
end
