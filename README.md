Vagrant Multi-VM Development Environment with Automated Provisioning Scripts

This project provides a fully automated multi-machine local development environment using Vagrant and VirtualBox, designed for testing and development of web applications with supporting services like databases, caching, and message brokers.

The environment consists of five virtual machines, each with a specific role, network configuration, and dedicated provisioning script to automate setup and configuration.

Overview

Managing a complex development environment with multiple services can be time-consuming and error-prone. This project solves that problem by:

Using Vagrant to define and manage multiple virtual machines in a single configuration.

Automating the setup of each VM using shell scripts.

Providing a reproducible and consistent environment that can be quickly brought up, modified, or destroyed.

Ensuring all VMs can communicate with each other using private network IPs, managed automatically with recommended plugins.

By leveraging scripts for provisioning, all software installation, configuration, and service setup are automated, reducing manual intervention and making the environment fully reproducible.

Prerequisites

Ensure your system has the following installed:

VirtualBox
 – to run virtual machines

Vagrant
 – to orchestrate VMs

Recommended Plugin

For automatic management of /etc/hosts and VM hostname resolution, install:

vagrant plugin install vagrant-hostmanager


This allows seamless communication between VMs without manually editing hosts files.

Virtual Machines

The environment consists of five VMs, all running CentOS Stream 9 (eurolinux-vagrant/centos-stream-9):

Hostname	IP Address	Memory	Role / Provisioning Script
web01	192.168.56.11	1024MB	Web Server (web01.sh)
app01	192.168.56.12	4096MB	Application Server (app01.sh)
rmq01	192.168.56.13	1024MB	RabbitMQ Server (rmq01.sh)
mc01	192.168.56.14	1024MB	Memcached Server (mc01.sh)
db01	192.168.56.15	2048MB	Database Server (db01.sh)
Automation with Scripts

Each VM is provisioned using a dedicated shell script located in the project root:

Web Server (web01.sh): Installs Nginx, configures reverse proxy, and sets up firewall rules.

Application Server (app01.sh): Installs Java, Maven, Tomcat, and sets up deployment directories for web applications.

RabbitMQ Server (rmq01.sh): Installs and configures RabbitMQ with default users and permissions.

Memcached Server (mc01.sh): Installs Memcached and configures it to be accessible from other VMs.

Database Server (db01.sh): Installs MariaDB, creates databases, users, and configures network access.

Using scripts ensures that all VMs are set up consistently every time, eliminating manual configuration errors and saving setup time.

Usage
Bringing Up the Environment

To start all VMs:

vagrant up


To start a specific VM (e.g., web01):

vagrant up web01

Accessing VMs

SSH into any VM with:

vagrant ssh <hostname>


Example:

vagrant ssh app01

Stopping the Environment

To stop all running VMs:

vagrant halt


To completely remove all VMs and reset the environment:

vagrant destroy

Re-Provisioning

Since all VM setup is automated via scripts, you can re-run the provisioning scripts at any time without destroying the VMs:

vagrant provision


Or for a specific VM:

vagrant provision db01


This will reapply all configurations, install missing packages, or update services according to the scripts.

Benefits of Script-Based Automation

Consistency: Every VM is set up in exactly the same way every time.

Speed: New environments can be provisioned quickly.

Reproducibility: Easy to destroy and recreate the environment for testing or updates.

Ease of Use: Minimal manual steps required; everything is automated via scripts.

Summary

This project provides a robust, automated, and reproducible local development environment with multiple VMs for web, application, messaging, caching, and database services. By using Vagrant with dedicated provisioning scripts, setup and configuration are fully automated, making it easy to deploy, test, and develop complex multi-service applications locally.
