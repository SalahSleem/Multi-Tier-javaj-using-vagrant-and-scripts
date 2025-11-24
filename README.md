Vagrant Multi-VM Environment

This project provisions a complete multi-tier application stack using Vagrant + VirtualBox.
It creates five CentOS Stream 9 VMs, each assigned a specific service:

Nginx (reverse proxy)

Tomcat (Java app server)

MariaDB (Database)

Memcached (Caching layer)

RabbitMQ (Message broker)

This environment replicates a production-like microservices setup for local development and testing.

🚀 Prerequisites

Before using this project, install:

VirtualBox

Vagrant

Recommended plugin:

vagrant plugin install vagrant-hostmanager


This plugin automatically updates /etc/hosts on your host and VMs for easier communication (web01 → 192.168.56.x etc.)

🖥️ Virtual Machines Overview

All VMs use the base box:

eurolinux-vagrant/centos-stream-9

Hostname	IP Address	Memory	Description	Provision Script
web01	192.168.56.11	1024MB	Nginx Reverse Proxy	web01.sh
app01	192.168.56.12	4096MB	Tomcat + Java WAR Deployment	app01.sh
rmq01	192.168.56.13	1024MB	RabbitMQ Server	rmq01.sh
mc01	192.168.56.14	1024MB	Memcached Server	mc01.sh
db01	192.168.56.15	2048MB	MariaDB Database	db01.sh
▶️ Usage
Start all VMs
vagrant up

Start one VM
vagrant up web01

SSH into a VM
vagrant ssh <hostname>
# Example
vagrant ssh app01

Re-provision a VM
vagrant provision
# or
vagrant provision app01

Stop all VMs
vagrant halt

Destroy all VMs
vagrant destroy -f

📦 Provision Scripts (Full Descriptions)

Below is a summary of each provisioning script in your environment.

🔵 1. app01.sh — Tomcat + Java App Deployment

This script:

Installs Java 11, Git, Maven, and Wget

Downloads and installs Tomcat 9.0.75

Creates a systemd service for Tomcat

Clones the application source from GitHub

Overwrites application.properties with correct hosts and credentials

Runs:

mvn install


Deploys vprofile-v2.war as ROOT.war to Tomcat

Restarts Tomcat

Purpose: This VM is your main Application Server.

🔵 2. db01.sh — MariaDB Database Setup

This script:

Installs MariaDB + dependencies

Starts and enables MariaDB service

Creates:

Database: accounts

User: admin with password admin123

Grants full privileges

Imports db_backup.sql from your GitHub repo

Restarts MariaDB

Purpose: Hosts your database and initial seed data.

🔵 3. mc01.sh – Memcached Installation

This script:

Installs Memcached

Starts and enables the service

Opens port 11211/tcp in firewall

Provides Memcached configuration information

Purpose: Provides caching service used by the app.

🔵 4. rmq01.sh – RabbitMQ Installation

This script:

Adds necessary RabbitMQ repositories

Installs Erlang + RabbitMQ Server

Enables RabbitMQ and management plugin

Creates:

user: admin
pass: admin123


Opens ports:

5672/tcp (AMQP)

15672/tcp (management console)

Purpose: Provides messaging/queue service for your application.

🔵 5. web01.sh — Nginx Reverse Proxy

This script:

Installs Nginx

Enables firewall for ports 80 & 443

Removes default site

Creates a reverse proxy:

http://192.168.56.12:8080/


Enables the site and restarts Nginx

Purpose: Acts as the public entry point to your Tomcat application.

🧩 Architecture Overview
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

📖 Conclusion

This Vagrant environment gives you a full production-like stack locally:

Reverse Proxy (Nginx)

Application Layer (Tomcat + WAR)

Database Layer (MariaDB)

Caching Layer (Memcached)

Messaging Layer (RabbitMQ)

It is ideal for development, testing, and learning multi-tier DevOps setups.
