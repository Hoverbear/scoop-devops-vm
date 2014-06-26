# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# Query Engine Params
QE_NAME = "queryengine"
QEDB_NAME = "queryenginedb"
QE_PORT = 8080

# Visualization Engine Params
VIS_NAME = "visualizer"
VISDB_NAME = "visualizerdb"
VIS_PORT = 8081

# Configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "phusion/ubuntu-14.04-amd64"
    config.vm.hostname = "scoop"

    config.vm.provider "virtualbox" do |v|
      v.name = "scoop"
    end

    # Private network
    config.vm.network "private_network", type: "dhcp"
    # NFS share. Better supported.
    config.vm.synced_folder ".", "/vagrant", type: "nfs"

    # Forward the SSH Agent
    config.ssh.forward_agent = true

    # Network
    config.vm.network "forwarded_port", guest: QE_PORT, host: QE_PORT
    config.vm.network "forwarded_port", guest: VIS_PORT, host: VIS_PORT

    # Docker Configurations
    # Need to re-provision? Run this in the host: `docker stop $(docker ps -aq) && docker rm $(docker ps -aq) && docker rmi visualizer queryengine`
    config.vm.provision "docker" do |d|
        ### Pull & Build ##
        # Pull necessary images.
        d.pull_images "mongo"
        d.pull_images "node"
        # Build images.
        d.build_image "/vagrant/queryengine",
            args: "-t 'queryengine'"
        d.build_image "/vagrant/visualizer",
            args: "-t 'visualizer'"

        ### Start ###
        # Start Query Engine MongoDB
        d.run QEDB_NAME,
            image: "mongo",
            args: "-P"
        # Start Query Engine
        d.run QE_NAME,
            image: "queryengine",
            args: "--link #{QEDB_NAME}:#{QEDB_NAME} -p #{QE_PORT}:8080 -v /vagrant/queryengine:/app"
        # Start Visualizer MongoDB
        d.run VISDB_NAME,
            image: "mongo",
            args: "-P"
        # Start Visualizer
        d.run VIS_NAME,
            image: "visualizer",
            args: "--link #{VISDB_NAME}:#{VISDB_NAME} --link #{QE_NAME}:queryengine -p #{VIS_PORT}:8081 -v /vagrant/visualizer:/app"
    end

    # If you change any of the variables you need to edit this script.
    config.vm.provision "shell", path: "db-data/setup.sh"

end
