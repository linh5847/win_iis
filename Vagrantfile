# -*- mode: ruby -*-
# vi: set ft=ruby :

# -*- mode: ruby -*-
# vi: set ft=ruby :

# $basic_auth = <<SCRIPT
# Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
# SCRIPT

# $allow_execution_on_powershell = <<SCRIPT
# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
# SCRIPT

# $ansible_remoting_script = <<SCRIPT
# iwr vagrant/ConfigureRemotingForAnsible.ps1 -UseBasicParsing | iex
# SCRIPT

# $ansible_remoting_script = <<SCRIPT
# iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
# SCRIPT

Vagrant.require_version ">= 1.6.2"

Vagrant.configure("2") do |config|
  config.vm.define "windows2019"
  config.vm.box = "jborean93/WindowsServer2019"
  config.vm.communicator = "winrm"
  #config.winrm.host = "192.168.56.180"
  config.winrm.ssl_peer_verification = false
  #config.vm.boot_timeout = 900

  # Admin user name and password
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.guest = :windows
  config.windows.halt_timeout = 60

  config.vm.network "private_network", ip: "192.168.56.180"
  # config.vm.provision "shell", privileged: "true", powershell_elevated_interactive: "true", inline: <<-SHELL
  #   Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
  #   Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -Force
  # SHELL
  #config.vm.provision "shell", path: "vagrant/ConfigureRemotingForAnsible.ps1", privileged: true, powershell_elevated_interactive: "true"

  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.network :forwarded_port, guest: 3389, host: 3389, id: "rdp", auto_correct: true
  #config.vm.synced_folder "./vagrant", "C:\\vagrant\\vagrant"

  config.vm.provider :virtualbox do |v, override|
    v.gui = true
    v.customize ["modifyvm", :id, "--memory", 8192]
    v.customize ["modifyvm", :id, "--cpus", 2]
    v.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]

    file_to_disk = File.realpath( "." ).to_s + "/disk.vdi"
    if ARGV[0] == "up" && ! File.exist?(file_to_disk)
      v.customize [
        'createhd',
        '--filename', file_to_disk,
        '--format', 'VDI',
        '--size', 30 * 1024 # 30 GB
      ]
      v.customize [
        'storageattach', :id,
        '--storagectl', 'SATA', # The name may vary
        '--port', 1, '--device', 0,
        '--type', 'hdd', '--medium',
        file_to_disk
      ]
    end
    
    filetodisk = File.realpath( "." ).to_s + "/disk1.vdi"
    if ARGV[0] == "up" && ! File.exist?(filetodisk)
      v.customize [
        'createhd',
        '--filename', filetodisk,
        '--format', 'VDI',
        '--size', 30 * 1024 # 30 GB
      ]
      v.customize [
        'storageattach', :id,
        '--storagectl', 'SATA', # The name may vary
        '--port', 2, '--device', 0,
        '--type', 'hdd', '--medium',
        filetodisk
      ]
    end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.compatibility_mode = "2.0"
    ansible.playbook = "setup.yml"
    ansible.inventory_path = "inventory.ini"
    ansible.verbose = "-vvv"
  end
end