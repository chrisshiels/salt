# Salt

Salt configuration with roles, profiles and hierarchical variables as influenced
by Puppet roles and profiles pattern with Hiera.


# Overview

1.  Every host has a file /etc/salt/grains specifying grains for the
    host's region, datacentre, application, environment and role.
    Here this is configured by Vagrantfile, e.g.

```
    vagrant@vm1:~$ cat /etc/salt/grains
    region: emea
    datacentre: local
    application: webapp
    environment: dev
    role: docker
```


2.  In /srv/pillar/top.sls the grains region, datacentre, application,
    environment and role are used to dynamically construct a list of pillar
    includes under the /srv/pillar/hierarchy/ directory where successive
    includes override prior includes, e.g.

```
    vagrant@vm1:~$ find /srv/pillar/hierarchy/ | sort
    /srv/pillar/hierarchy/
    /srv/pillar/hierarchy/common.sls
    /srv/pillar/hierarchy/emea
    /srv/pillar/hierarchy/emea/init.sls
    /srv/pillar/hierarchy/emea/local
    /srv/pillar/hierarchy/emea/local/webapp
    /srv/pillar/hierarchy/emea/local/webapp/dev
    /srv/pillar/hierarchy/emea/local/webapp/dev/init.sls
```


3.  In /srv/salt/top.sls the grain role is used to include a role state from
    /srv/salt/roles/ which in turn includes profile states from
    /srv/salt/profiles/ and module states from /srv/salt/modules/, e.g.

    * /srv/salt/roles/docker.sls includes profiles/base and modules/docker.
    * /srv/salt/profiles/base.sls includes modules/common, modules/motd and
      modules/repositories.


## Quickstart

    host$ # Hypervisor setup - here under Fedora 36.
    host$ sudo virsh net-define vagrant.xml
    host$ sudo virsh net-start vagrant
    host$ sudo virsh net-autostart vagrant
    host$ sudo firewall-cmd --zone libvirt --add-service rpc-bind --permanent
    host$ sudo firewall-cmd --zone libvirt --add-service mountd --permanent
    host$ sudo firewall-cmd --zone libvirt --add-service nfs --permanent
    host$ sudo /bin/systemctl restart firewalld.service


    host$ # Start virtual machines and connect to Salt master.
    host$ vagrant up
    host$ vagrant ssh vm1


    vagrant@vm1:~$ # Accept connections from Salt minions.
    vagrant@vm1:~$ sudo salt-key --list-all
    vagrant@vm1:~$ sudo salt-key --yes --accept vm1
    vagrant@vm1:~$ sudo salt-key --yes --accept vm2
    vagrant@vm1:~$ sudo salt-key --yes --accept vm3


    vagrant@vm1:~$ # Test connectivity.
    vagrant@vm1:~$ sleep 10 ; sudo salt '*' test.ping


    vagrant@vm1:~$ # Configure /srv/.
    vagrant@vm1:~$ sudo ln -s /vagrant/salt/salt/ /srv/
    vagrant@vm1:~$ sudo ln -s /vagrant/salt/pillar/ /srv/


    vagrant@vm1:~$ # Apply.
    vagrant@vm1:~$ sudo salt --timeout 60 '*' state.apply
    vagrant@vm1:~$ sudo salt --state-output mixed '*' state.apply
    vagrant@vm1:~$ sudo salt --state-verbose false '*' state.apply


## To do

1.  Explore using docker-compose with testinfra to implement Molecule style
    tests.

2.  Explore centralising the host's region, datacentre, application, environment
    and role from /etc/salt/grains to the master.
