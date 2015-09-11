# The `puppetmaster` role sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class role::master {
  include 'git'
  include 'apache'
  include 'profile::pe_env'
  include 'profile::firewall'

  # Detect Vagrant
  case $::virtual {
    'virtualbox': {
      $srv_root     = '/var/seteam-files'
      $apache_user  = 'vagrant'
      $apache_group = 'vagrant'
    }
    default: {
      $srv_root     = '/opt/seteam-files'
      $apache_user  = 'root'
      $apache_group = 'root'
    }
  }

  # Set up Apache to serve static files
  apache::vhost { 'seteam-files':
    vhost_name    => '*',
    port          => '80',
    docroot       => $srv_root,
    priority      => '10',
    docroot_owner => $apache_user,
    docroot_group => $apache_group,
  }

  # Puppet master firewall rules
  Firewall {
    require => Class['profile::firewall::pre'],
    before  => Class['profile::firewall::post'],
    chain   => 'INPUT',
    proto   => 'tcp',
    action  => 'accept',
  }

  firewall { '110 puppetmaster allow all': dport  => '8140';  }
  firewall { '110 dashboard allow all':    dport  => '443';   }
  firewall { '110 mcollective allow all':  dport  => '61613'; }
  firewall { '110 apache allow all':       dport  => '80';    }

  ##################
  # Configure Puppet
  ##################

  class { 'hiera':
    datadir_manage => false,
    notify         => Service['pe-puppetserver'],
    hierarchy      => [
      'nodes/%{clientcert}',
      'environment/%{environment}',
      'datacenter/%{datacenter}',
      'virtual/%{virtual}',
      'common',
    ],
  }

  # We have to manage this file like this because of ROAD-706
  $key = file('role/license.key')
  exec { 'Create License':
    command => "/bin/echo \"${key}\" > /etc/puppetlabs/license.key",
    creates => '/etc/puppetlabs/license.key',
  }

  # SET-84 Turn off Dujour / telemetry for demo env for 2015.2
   file { '/etc/puppetlabs/puppetserver/opt-out':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }
}
