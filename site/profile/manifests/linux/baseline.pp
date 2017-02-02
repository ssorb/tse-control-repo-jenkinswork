class profile::linux::baseline {
  class { 'apache':
    default_vhost => false,
  }

  package { 'unzip':
    ensure => installed,
  }

  package { 'git':
    ensure => installed,
  }

  # USERS
  user { 'Puppet Demo':
    ensure   => present,
  }
}
