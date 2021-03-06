# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# Update apt and get dependencies
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y unzip curl vim \
    apt-transport-https \
    ca-certificates \
    software-properties-common

# Download Nomad
NOMAD_VERSION=0.8.2
CONSUL_VERSION=1.0.7

echo "Fetching Nomad..."
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip

echo "Fetching Consul..."
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip

echo "Installing Nomad..."
unzip nomad.zip
sudo install nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

# Set hostname's IP to made advertisement Just Work
#sudo sed -i -e "s/.*nomad.*/$(ip route get 1 | awk '{print $NF;exit}') nomad/" /etc/hosts

echo "Installing Docker..."
if [[ -f /etc/apt/sources.list.d/docker.list ]]; then
    echo "Docker repository already installed; Skipping"
else
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
fi
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce

# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart

# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant

echo "Installing Consul..."
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
(
cat <<-EOF
	[Unit]
	Description=consul agent
	Requires=network-online.target
	After=network-online.target
	
	[Service]
	Restart=on-failure
	ExecStart=/usr/bin/consul agent -dev
	ExecReload=/bin/kill -HUP $MAINPID
	
	[Install]
	WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul

for bin in cfssl cfssl-certinfo cfssljson
do
	echo "Installing $bin..."
	curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
	sudo install /tmp/${bin} /usr/local/bin/${bin}
done

echo "Installing autocomplete..."
nomad -autocomplete-install

SCRIPT

Vagrant.configure(2) do |config|
  
# Starting Server
  config.vm.define "server" do |server|
    server.vm.box = "bento/ubuntu-16.04" # 16.04 LTS
    server.vm.hostname = "server"
    server.vm.provision "shell", inline: $script, privileged: false
    server.vm.provision "docker" # Just install it
    
    server.vm.network "public_network", type: "dhcp", bridge: "enp0s31f6"

    # Expose the nomad api and ui to the host
    server.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true

    # Increase memory for Virtualbox
    server.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    server.vm.provision "shell", path: "./print_ip.sh", privileged: false

  end # end of server


# Starting Client 1
  config.vm.define "cl1" do |cl1|
    cl1.vm.box = "bento/ubuntu-16.04" # 16.04 LTS
    cl1.vm.hostname = "client-1"
    cl1.vm.provision "shell", inline: $script, privileged: false
    cl1.vm.provision "docker" # Just install it
    
    cl1.vm.network "public_network", type: "dhcp", bridge: "enp0s31f6"

    # Expose the nomad api and ui to the host
    cl1.vm.network "forwarded_port", guest: 4646, host: 4647, auto_correct: true


    # Increase memory for Virtualbox
    cl1.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    cl1.vm.provision "shell", path: "./print_ip.sh", privileged: false

  end # end of cl1

# Starting Client 2
  config.vm.define "cl2" do |cl2|
    cl2.vm.box = "bento/ubuntu-16.04" # 16.04 LTS
    cl2.vm.hostname = "client-2"
    cl2.vm.provision "shell", inline: $script, privileged: false
    cl2.vm.provision "docker" # Just install it
    
    cl2.vm.network "public_network", type: "dhcp", bridge: "enp0s31f6"

    # Expose the nomad api and ui to the host
    cl2.vm.network "forwarded_port", guest: 4646, host: 4648, auto_correct: true


    # Increase memory for Virtualbox
    cl2.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    cl2.vm.provision "shell", path: "./print_ip.sh", privileged: false

   end # end of cl2

# # Starting Client 3
#   config.vm.define "cl3" do |cl3|
#     cl3.vm.box = "bento/ubuntu-16.04" # 16.04 LTS
#     cl3.vm.hostname = "client-3"
#     cl3.vm.provision "shell", inline: $script, privileged: false
#     cl3.vm.provision "docker" # Just install it
    
#     cl3.vm.network "public_network", type: "dhcp", bridge: "enp0s31f6"

#     # Expose the nomad api and ui to the host
#     cl3.vm.network "forwarded_port", guest: 4646, host: 4649, auto_correct: true


#     # Increase memory for Virtualbox
#     cl3.vm.provider "virtualbox" do |vb|
#       vb.memory = "1024"
#     end

#     cl3.vm.provision "shell", path: "./print_ip.sh", privileged: false

#   end # end of cl3
  
end # ned of the Vagrant.configure
