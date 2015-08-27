# This profile is intended to demonstrate the provisioning and basic configuration of vmware using the vsphere module
class profile::vsphere (
  $vspherehost     = 'tse-vc1-prod.corp.puppetlabs.net',
  $vsphereusername = 'testuser@vsphere.local',
  $vspherepassword = 'puppetlabs',
  $status          = 'running',
  $template        = '/west1/vm/Templates/centos-6-x86_64-noagent-ssd',
  #This is required, please check before clobbering someone else's vms
  $folder,
  ){
  #Install required packages for vsphere management
  $packages = [zlib-devel,libxslt-devel,patch,gcc]
  package { $packages:
    ensure => present,
  }

  #Install required gems for vsphere management
  $gems = [rbvmomi,hocon]
  package { $gems:
    provider => puppet_gem,
    ensure => present,
  }

  #Configure host/credentials for vsphere host
  file { '/etc/puppetlabs/puppet/vcenter.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('profile/vcenter.conf.erb'),
  }

  #Example VM
  #vsphere_vm { '/west1/vm/TSEs/${folder}/test1':
  #  ensure => $status,
  #  source => $template,
  #  memory => 1024,
  #  cpus   => 2,
  #}

  #Purging example:
  #resources { 'vsphere_vm':
  #  purge => true,
  #  noop  => true,
  #}

  #Relationship example:
  vsphere_vm { "/west1/vm/TSEs/${folder}/mydatabase":
    ensure => running,
    source => $template,
    memory => 2048,
    cpus   => 2,
  }
  vsphere_vm { "/west1/vm/TSEs/${folder}/mywebserver1":
    ensure  => running,
    source  => $template,
    memory  => 1024,
    cpus    => 1,
    require => Vsphere_vm["/west1/vm/TSEs/${folder}/mydatabase"]
  }
  vsphere_vm { "/west1/vm/TSEs/${folder}/mywebserver2":
    ensure  => running,
    source  => $template,
    memory  => 1024,
    cpus    => 1,
    require => Vsphere_vm["/west1/vm/TSEs/${folder}/mydatabase"]
  }
  vsphere_vm { "/west1/vm/TSEs/${folder}/myloadbalancer":
    ensure  => running,
    source  => $template,
    memory  => 512,
    cpus    => 1,
    require => Vsphere_vm["/west1/vm/TSEs/${folder}/mywebserver1","/west1/vm/TSEs/${folder}/mywebserver2"]
  }
}
