VM_CONFIG = {
  vm_name: ENV['vm_name'],
  name: ENV['definition_name'],
  box: ENV['box'],
  hostname: ENV['hostname'],
  memory: ENV['memory'].to_i,
  cpus: ENV['cpu'].to_i,
  vram: ENV['vram'].to_i,
  network_type: ENV['network_type'],
  ip: ENV['ip'],
  description: ENV['description']
}

Vagrant.configure("2") do |config|
  config.vm.define VM_CONFIG[:name] do |server|
    server.vm.box = VM_CONFIG[:box]
    server.vm.network VM_CONFIG[:network_type], ip: VM_CONFIG[:ip]
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
    if VM_CONFIG[:box].include?("ubuntu") || VM_CONFIG[:box].include?("centos")
      server.vm.provision "shell", path: "scripts/update.sh"
      server.vm.provision "shell", path: "scripts/create_user.sh"
      server.vm.provision "shell", path: "scripts/docker.sh"
    elsif VM_CONFIG[:box].include?("windows")
      server.vm.provision "shell", path: "scripts/stop_windows_update.bat", privileged: false
    end
  end
end
