class profile::master::fileserver {
  include 'stdlib'
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

  apache::vhost { 'tse-files':
    vhost_name    => '*',
    port          => '80',
    docroot       => '/opt/tse-files',
    priority      => '10',
    docroot_owner => $apache_user,
    docroot_group => $apache_group,
  }

  firewall { '110 apache allow all':
    dport  => '80',
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  # The *::finalize class includes some configuration that should be applied
  # after everything is up and fully operational. Some of this configuration is
  # used to signal to external watchers that the master is fully configured and
  # ready.
  class { 'profile::master::fileserver::finalize':
    stage => 'deploy_app',
  }

}
