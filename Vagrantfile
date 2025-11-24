Vagrant.configure("2") do |config|

  # -------------------------------
  # VM1 – WEB SERVER (Ubuntu + NGINX)
  # -------------------------------
  config.vm.define "web01" do |web|
    web.vm.box = "ubuntu/trusty64"
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.56.10"

    web.vm.provider "virtualbox" do |vb|
      vb.memory = 800
    end

    web.vm.provision "shell", path: "./scripts/provision_web.sh"
  end

  # -------------------------------
  # VM2 – APP SERVER (Tomcat)
  # -------------------------------
  config.vm.define "app01" do |app|
    app.vm.box = "eurolinux-vagrant/centos-stream-9"
    app.vm.hostname = "app"
    app.vm.network "private_network", ip: "192.168.56.11"

    app.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    app.vm.provision "shell", path: "./scripts/provision_app.sh"
  end

  # -------------------------------
  # VM3 – RabbitMQ
  # -------------------------------
  config.vm.define "rmq01" do |rmq|
    rmq.vm.box = "eurolinux-vagrant/centos-stream-9"
    rmq.vm.hostname = "rmq01"
    rmq.vm.network "private_network", ip: "192.168.56.12"

    rmq.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    rmq.vm.provision "shell", path: "./scripts/provision_rmq.sh"
  end

  # -------------------------------
  # VM4 – MEMCACHED
  # -------------------------------
  config.vm.define "mc01" do |mc|
    mc.vm.box = "eurolinux-vagrant/centos-stream-9"
    mc.vm.hostname = "mc01"
    mc.vm.network "private_network", ip: "192.168.56.13"

    mc.vm.provider "virtualbox" do |vb|
      vb.memory = 900
    end

    mc.vm.provision "shell", path: "./scripts/provision_mc.sh"
  end

  # -------------------------------
  # VM5 – MariaDB
  # -------------------------------
  config.vm.define "db01" do |db|
    db.vm.box = "eurolinux-vagrant/centos-stream-9"
    db.vm.hostname = "db01"
    db.vm.network "private_network", ip: "192.168.56.14"

    db.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    db.vm.provision "shell", path: "./scripts/provision_db.sh"
  end

end
