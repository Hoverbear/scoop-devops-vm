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

# OAuth Params
CONSUMER_KEY = 'visualizer'
CONSUMER_SECRET = 'specialsecret'

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
            args: "-d"
        # Start Query Engine
        d.run QE_NAME,
            image: "queryengine",
            args: "--link #{QEDB_NAME}:mongo -p #{QE_PORT}:8080 -d -v /vagrant/queryengine:/app"
        # Start Visualizer MongoDB
        d.run VISDB_NAME,
            image: "mongo",
            args: "--name #{VISDB_NAME} -d"
        # Start Visualizer
        d.run VIS_NAME,
            image: "visualizer",
            args: "--link #{VISDB_NAME}:mongo --link #{QE_NAME}:queryengine -p #{VIS_PORT}:8081 -d -v /vagrant/visualizer:/app -e 'CONSUMER_KEY=#{CONSUMER_KEY}' -e 'CONSUMER_SECRET=#{CONSUMER_SECRET}'"
    end
end
