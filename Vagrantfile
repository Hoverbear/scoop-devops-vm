# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

# Query Engine Params
QE_NAME = "queryengine"
QEDB_NAME = "queryengine-db"
QE_PORT = 8080

# Visualization Engine Params
VIS_NAME = "visualizer"
VISDB_NAME = "visualizer-db"
VIS_PORT = 8081

# Configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "phusion/ubuntu-14.04-amd64"
    config.vm.hostname = "scoop"

    config.vm.provider "virtualbox" do |v|
      v.name = "scoop"
    end

    # Forward the SSH Agent
    config.ssh.forward_agent = true

    # Network
    config.vm.network "forwarded_port", guest: QE_PORT, host: QE_PORT
    config.vm.network "forwarded_port", guest: VIS_PORT, host: VIS_PORT

    # Docker Configurations
    config.vm.provision "docker" do |d|
        ### Pull & Build ##
        # Pull necessary images.
        d.pull_images "mongo"
        d.pull_images "node"
        # Build images.
        d.build_image "/vagrant/queryengine",
            args: "-t 'queryengine'"
        # d.build_image "/vagrant/vis",
        #     args: "-t 'vis'"

        ### Start ###
        # Start Query Engine MongoDB
        d.run "mongo",
            args: "--name #{QEDB_NAME} -d"
        # Start Query Engine
        d.run "queryengine",
            args: "--name #{QE_NAME} --link #{QEDB_NAME}:mongo -p #{QE_PORT}:8080 -d -v /vagrant/queryengine:/app"
        # Start Visualizer MongoDB
        # d.run "mongo",
        #     args: "--name #{VISDB_NAME} -d"
        # Start Query Engine
        # d.run "vis",
        #     args: "--name #{VIS_NAME} --link #{VISDB_NAME}:mongo -p #{VIS_PORT}:8080 -d -v /vagrant/vis:/app"
    end
end
