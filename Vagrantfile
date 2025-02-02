VM_CONFIG = {
  name: ENV['name'],
  box: ENV['box'],
  ip: ENV['ip'],
  hostname: ENV['hostname'],
  vm_name: ENV['vm_name'],
  memory: ENV['memory'].to_i,
  cpus: ENV['cpu'].to_i,
  vram: ENV['vram'].to_i,
  network_type: ENV['network_type'],
  description: ENV['description']
}

Vagrant.configure("2") do |config|
  config.vm.define VM_CONFIG[:name] do |VM_CONFIG[:name]|
    VM_CONFIG[:name].vm.box = VM_CONFIG[:box]
    VM_CONFIG[:name].vm.network VM_CONFIG[:network_type], ip: VM_CONFIG[:ip]
    VM_CONFIG[:name].vm.hostname = VM_CONFIG[:hostname]
    VM_CONFIG[:name].vm.provider "virtualbox" do |vb|
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
      VM_CONFIG[:name].vm.provision "shell", path: "scripts/update.sh"
      VM_CONFIG[:name].vm.provision "shell", path: "scripts/create_user.sh"
      VM_CONFIG[:name].vm.provision "shell", path: "scripts/docker.sh"
    elsif VM_CONFIG[:box].include?("windows")
      VM_CONFIG[:name].vm.provision "shell", path: "scripts/stop_windows_update.bat", privileged: false
    end
  end
end
