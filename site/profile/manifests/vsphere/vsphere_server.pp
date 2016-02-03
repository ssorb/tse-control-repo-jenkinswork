# This profile is intended to demonstrate the provisioning and basic configuration of vmware using the vsphere module
class profile::vsphere::vsphere_server (
  $vspherehost     = 'tse-vc1-prod.corp.puppetlabs.net',
  $vspheredatacenter = 'west1',
  $vsphereusername = 'testuser@vsphere.local',
  $vspherepassword = 'puppetlabs',
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
}
