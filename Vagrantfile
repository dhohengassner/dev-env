# -*- mode: ruby -*-
# vi: set ft=ruby :


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.name = "docker_dev"
    vb.gui = false
    vb.memory = 1024*10
    vb.cpus = 4
    # Enabling the I/O APIC is required for 64-bit guest operating systems, especially Windows Vista;
    # it is also required if you want to use more than one virtual CPU in a VM.
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    # Enable the use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]

  end

  config.vm.provision "shell" do |s|
    ssh_pub_key = File.open("#{Dir.home}/.ssh/id_rsa.pub").read
    ssh_priv_key = File.open("#{Dir.home}/.ssh/id_rsa").read
    s.inline = <<-SHELL
      echo "#{ssh_pub_key}" > /home/vagrant/.ssh/id_rsa.pub
      echo "#{ssh_priv_key}" > /home/vagrant/.ssh/id_rsa
      chown vagrant /home/vagrant/.ssh/id_rsa
      chmod 600 /home/vagrant/.ssh/id_rsa
      chown vagrant /home/vagrant/.ssh/id_rsa.pub
      chmod 600 /home/vagrant/.ssh/id_rsa.pub
      echo "#{ssh_pub_key}" >> /home/vagrant/.ssh/authorized_keys
      echo "#{ssh_pub_key}" >> /root/.ssh/authorized_keys
    SHELL
  end

  config.vm.provision "shell", path: "base.sh"

  #-------------------------------------
  # Local customizations to VM
  #-------------------------------------
  # Check if ~/.gitconfig exists locally
  # If so, copy basic Git Config settings to Vagrant VM
  # This lets developers easily commit code to Bitbucket as themselves
  if File.exists?(File.join(Dir.home, ".gitconfig"))
      git_name = `git config user.name`   # find locally set git name
      git_email = `git config user.email` # find locally set git email
      # set git name for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git username to VM...' && sudo -i -u vagrant git config --global user.name '#{git_name.chomp}'"
      # set git email for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git email to VM...' && sudo -i -u vagrant git config --global user.email '#{git_email.chomp}'"
  end

  config.vm.provision "shell", path: "ansible.sh"
  config.vm.provision "shell", path: "devMachine.sh"

  config.vm.synced_folder "../", "/repos"

  # use fixed ip as target for ssh
  config.vm.network 'private_network', ip: '192.168.100.22'

  config.vm.network "forwarded_port", guest: 3000, host: 13000
  config.vm.network "forwarded_port", guest: 8080, host: 18080
  config.vm.network "forwarded_port", guest: 9090, host: 19090

end
