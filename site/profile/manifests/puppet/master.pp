# The `puppetmaster` profile sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class profile::puppet::master {
  include 'git'
  include 'apache'
  include 'profile::firewall'

  # Detect Vagrant
  case $::virtual {
    'virtualbox': {
      $apache_user  = 'vagrant'
      $apache_group = 'vagrant'
    }
    default: {
      $apache_user  = 'root'
      $apache_group = 'root'
    }
  }

  # Set up Apache to serve static files
  apache::vhost { 'seteam-files':
    vhost_name    => '*',
    port          => '80',
    docroot       => '/opt/tse-files',
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
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    hierarchy      => [
      'nodes/%{clientcert}',
      'environment/%{environment}',
      'datacenter/%{datacenter}',
      'virtual/%{virtual}',
      'common',
    ],
  }

  # We cannot simply set notify => Service['pe-puppetserver'] on Class['hiera']
  # because this profile is sometimes used by `puppet apply`, and other times
  # used in combination with pe-provided roles. So instead we'll collect the
  # service and add a subscribe relationship.
  Service <| title == 'pe-puppetserver' |> {
    subscribe +> Class['hiera'],
  }

  # We have to manage this file like this because of ROAD-706
  $key = file('profile/license.key')
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
