Vagrant.configure('2') do |config|
  config.vm.box = 'debian/buster64'

  config.vm.provider :libvirt do |domain|
    domain.uri = 'qemu:///system'
    domain.memory = 2048
    domain.cpus = 2
  end

  config.vm.provision 'shell', inline: <<eof
# Apt.
apt-get update
apt-get -y upgrade

# Salt Repository.
apt-get install -y gnupg
curl https://repo.saltproject.io/py3/debian/10/amd64/latest/salt-archive-keyring.gpg | apt-key add -

# Salt name.
echo '10.100.0.11 salt' | tee /etc/hosts

# Salt Master.
[ `hostname` = 'vm1' ] && apt-get install -y salt-master
        
# Salt Minion.
apt-get install -y salt-minion
tee /etc/salt/grains <<eof2
region: emea
datacentre: local
application: webapp
environment: dev
role: docker
eof2
sudo systemctl restart salt-minion.service
eof

  config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_udp: false

  config.vm.define 'vm1' do |vm1|
    vm1.vm.hostname = 'vm1'
    vm1.vm.network :private_network,
                   :ip => '10.100.0.11',
                   :libvirt__network_name => 'vagrant'
  end

  config.vm.define 'vm2' do |vm2|
    vm2.vm.hostname = 'vm2'
    vm2.vm.network :private_network,
                   :ip => '10.100.0.12',
                   :libvirt__network_name => 'vagrant'
  end

  config.vm.define 'vm3' do |vm3|
    vm3.vm.hostname = 'vm3'
    vm3.vm.network :private_network,
                   :ip => '10.100.0.13',
                   :libvirt__network_name => 'vagrant'
  end
end
