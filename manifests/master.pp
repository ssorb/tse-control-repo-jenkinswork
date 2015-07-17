# The `puppetmaster` role sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class role::master {

  # Detect Vagrant
  $srv_root = $::virtual ? {
    'virtualbox' => '/var/seteam-files',
      default    => '/opt/seteam-files',
  }
  $apache_user = $::virtual ? {
    'virtualbox' => 'vagrant',
    default      => 'root',
  }
  $apache_group = $::virtual ? {
    'virtualbox' => 'vagrant',
    default      => 'root',
  }

  # Custom PE Console configuration
  include git
  include apache

  # Puppet master firewall rules
  include profile::firewall
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

  apache::vhost { 'seteam-files':
    vhost_name    => '*',
    port          => '80',
    docroot       => $srv_root,
    priority      => '10',
    docroot_owner => $apache_user,
    docroot_group => $apache_group,
  }

  #Configure r10k to use seteam-puppet-environments
  file {'/root/.ssh':
    ensure => directory,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }->
  file { '/root/.ssh/known_hosts':
    ensure => 'file',
    group  => 'root',
    mode   => '0644',
    owner  => 'root',
  }->
  file_line { 'github_known_host':
    path => '/root/.ssh/known_hosts',
    line => 'github.com,192.30.252.130 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
  }->
  class { 'r10k':
    remote     => '/opt/puppet/repos/puppet-control.git',
    provider   => 'pe_gem',
    configfile => '/etc/puppetlabs/r10k/r10k.yaml',
  }

}
