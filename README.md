Vagrant Multi-VM Environment

This project sets up a multi-machine local development environment using Vagrant and VirtualBox. It provisions five virtual machines (VMs) that simulate a multi-tier application stack:

web01: Nginx reverse proxy

app01: Tomcat application server

rmq01: RabbitMQ message broker

mc01: Memcached caching server

db01: MariaDB database

The VMs communicate over a private network to replicate a realistic deployment environment.

Prerequisites

Make sure the following are installed on your system:

VirtualBox

Vagrant

Recommended Vagrant plugin for managing hosts:

vagrant plugin install vagrant-hostmanager

Virtual Machines Overview
Hostname	IP Address	Memory	Role / Provision Script
web01	192.168.56.10	800MB	Nginx reverse proxy (provision_web.sh)
app01	192.168.56.11	1024MB	Tomcat application server (provision_app.sh)
rmq01	192.168.56.12	1024MB	RabbitMQ server (provision_rmq.sh)
mc01	192.168.56.13	900MB	Memcached caching server (provision_mc.sh)
db01	192.168.56.14	1024MB	MariaDB server (provision_db.sh)
Architecture Diagram
            +--------------------+
            |     web01 (NGINX)  |
            | 192.168.56.11:80   |
            +---------+----------+
                      |
                      v
            +--------------------+
            |   app01 (Tomcat)   |
            | 192.168.56.12:8080 |
            +----------+---------+
             |         |         |
             |         |         |
       +-----+----+ +--+-----+ +-------+
       |  db01    | | mc01   | | rmq01 |
       | MariaDB  | | Memcache| |RabbitMQ|
       +----------+ +---------+ +--------+


Explanation:

web01 receives external requests and forwards them to app01 (Tomcat).

app01 connects to db01 (MariaDB) for persistent data, mc01 (Memcached) for caching, and rmq01 (RabbitMQ) for messaging.

Provisioning Scripts Overview

Each VM is provisioned with a shell script located in the ./scripts folder.

Script Name	Purpose / What it Does
provision_web.sh	Installs NGINX, configures it as a reverse proxy to app01, and opens firewall ports 80/443.
provision_app.sh	Installs Java, Maven, and Tomcat, clones the application source code, builds it with Maven, and deploys the .war to Tomcat. Also sets up host entries for VM communication.
provision_db.sh	Installs MariaDB, creates the accounts database, configures users and privileges, restores the database backup, and ensures MariaDB starts on boot.
provision_mc.sh	Installs Memcached, starts the service, enables it on boot, and opens firewall port 11211.
provision_rmq.sh	Installs Erlang and RabbitMQ, enables the management plugin, creates an admin user, and opens RabbitMQ ports (5672 for AMQP, 15672 for Management UI).
Usage
Start all VMs
vagrant up

Start a specific VM
vagrant up web01

SSH into a VM
vagrant ssh <hostname>
# Example:
vagrant ssh app01

Re-provision a VM
vagrant provision
# or for a specific VM
vagrant provision app01

Stop all VMs
vagrant halt

Destroy all VMs
vagrant destroy -f

Vagrant Configuration

All VM configurations are defined in Vagrantfile:

Sets VM box, hostname, IP address, and RAM

Defines provision scripts for each VM

Example for app01:

config.vm.define "app01" do |app|
  app.vm.box = "eurolinux-vagrant/centos-stream-9"
  app.vm.hostname = "app"
  app.vm.network "private_network", ip: "192.168.56.11"
  app.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
  end
  app.vm.provision "shell", path: "./scripts/provision_app.sh"
end
