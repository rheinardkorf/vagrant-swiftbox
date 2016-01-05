# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|

  # Store the current version of Vagrant for use in conditionals when dealing
  # with possible backward compatible issues.
  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  # Configurations from 1.0.x can be placed in Vagrant 1.1.x specs like the following.
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  # Forward Agent
  #
  # Enable agent forwarding on vagrant ssh commands. This allows you to use ssh keys
  # on your host machine inside the guest. See the manual for `ssh-add`.
  config.ssh.forward_agent = true

  # Default Ubuntu Box
  #
  # This box is provided by Ubuntu vagrantcloud.com and is a nicely sized (332MB)
  # box containing the Ubuntu 14.04 Trusty 64 bit release. Once this box is downloaded
  # to your host computer, it is cached for future use under the specified box name.
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "swiftbox"

  # Default Box IP Address
  #
  # This is the IP address that your host will communicate to the guest through. In the
  # case of the default `192.168.50.4` that we've provided, VirtualBox will setup another
  # network adapter on your host machine with the IP `192.168.50.1` as a gateway.
  #
  # If you are already on a network using the 192.168.50.x subnet, this should be changed.
  # If you are running more than one VM through VirtualBox, different subnets should be used
  # for those as well. This includes other Vagrant boxes.
  config.vm.network :private_network, ip: "192.168.100.4"

  # External IP Address (example)
  #
  # To enable outside access to the virtual machine, a line similar to the following is
  # required. Look for the IP address and adapter name in VirtualBox or by running
  # `vboxmanage list bridgedifs` in a terminal on the host system. The common adapter name
  # in OSX is `en0: Wi-Fi (AirPort)`. You will need to determine your adapter on windows.
  #
  # You can also let the guest machine use DHCP to assign an IP address.
  #
  # Using DHCP:
  config.vm.network :public_network
  #
  # Using an adapter bridge:
  # config.vm.network :public_network, :bridge => 'en0: Wi-Fi (AirPort)', ip: '192.168.2.101'

  # Drive mapping
  #
  # The following config.vm.synced_folder settings will map directories in your Vagrant
  # virtual machine to directories on your local machine. Once these are mapped, any
  # changes made to the files in these directories will affect both the local and virtual
  # machine versions. Think of it as two different ways to access the same file. When the
  # virtual machine is destroyed with `vagrant destroy`, your files will remain in your local
  # environment.

  # /srv/projects/
  #
  # If a projects directory exists in the same directory as your Vagrantfile,
  # a mapped directory inside the VM will be created that contains these files.
  config.vm.synced_folder "projects/", "/srv/projects"

  # Provisioning
  #
  # Process one or more provisioning scripts depending on the existence of custom files.
  #
  # provison-pre.sh acts as a pre-hook to our default provisioning script. Anything that
  # should run before the shell commands laid out in provision.sh (or your provision-custom.sh
  # file) should go in this script. If it does not exist, no extra provisioning will run.
  if File.exists?(File.join(vagrant_dir,'provision','provision-pre.sh')) then
    config.vm.provision :shell, :path => File.join( "provision", "provision-pre.sh" ), :args => ARGV
    config.vm.provision "source", :type => "shell", :path => File.join( "provision", "provision-pre.sh" ), :args => ARGV
  end

  # provision.sh or provision-custom.sh
  #
  # By default, Vagrantfile is set to use the provision.sh bash script located in the
  # provision directory. If it is detected that a provision-custom.sh script has been
  # created, that is run as a replacement. This is an opportunity to replace the entirety
  # of the provisioning provided by default.
  if File.exists?(File.join(vagrant_dir,'provision','provision-custom.sh')) then
    config.vm.provision :shell, :path => File.join( "provision", "provision-custom.sh" ), :args => ARGV
    config.vm.provision "source", :type => "shell", :path => File.join( "provision", "provision-custom.sh" ), :args => ARGV
  else
    config.vm.provision :shell, :path => File.join( "provision", "provision.sh" ), :args => ARGV
    config.vm.provision "source", :type => "shell", :path => File.join( "provision", "provision.sh" ), :args => ARGV
  end

  # provision-post.sh acts as a post-hook to the default provisioning. Anything that should
  # run after the shell commands laid out in provision.sh or provision-custom.sh should be
  # put into this file. This provides a good opportunity to install additional packages
  # without having to replace the entire default provisioning script.
  if File.exists?(File.join(vagrant_dir,'provision','provision-post.sh')) then
    config.vm.provision :shell, :path => File.join( "provision", "provision-post.sh" ), :args => ARGV
    config.vm.provision "source", :type => "shell", :path => File.join( "provision", "provision-post.sh" ), :args => ARGV
  end

  # Vagrant Triggers
  #
  # If the vagrant-triggers plugin is installed, we can run various scripts on Vagrant
  # state changes like `vagrant up`, `vagrant halt`, `vagrant suspend`, and `vagrant destroy`
  #
  # These scripts are run on the host machine, so we use `vagrant ssh` to tunnel back
  # into the VM and execute things.
  if defined? VagrantPlugins::Triggers
    config.trigger.before :halt, :stdout => true do
    # Commands to run when "vagrant halt" is called on the host machine
    #
    # To run a command on the guest machine, use "vagrant ssh -c <command>"
    #
    # Example:
    #   run "vagrant ssh -c 'my_shutdown_script'"
    end
    config.trigger.before :suspend, :stdout => true do
    # Commands to run when "vagrant suspend" is called on the host machine
    end
    config.trigger.before :destroy, :stdout => true do
    # Commands to run when "vagrant destroy" is called on the host machine
    end
  end
end
