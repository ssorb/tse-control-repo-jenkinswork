class profile::linux::baseline {
  class { 'apache':
    default_vhost => false,
  }

  package { 'unzip':
    ensure => installed,
  }

  # USERS
  user { 'PuppetDemo':
    ensure     => present,
    managehome => true,
    groups     => ['wheel'],
  }
}
