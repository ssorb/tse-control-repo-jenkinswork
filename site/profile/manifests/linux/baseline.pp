class profile::linux::baseline {
  package { 'unzip':
    ensure => installed,
  }

  # USERS
  user { 'PuppetDemo1':
    ensure     => present,
    managehome => true,
    groups     => ['wheel'],
    comment    => 'user for testing',
  }

  user { 'PuppetDemo2':
    ensure     => present,
    managehome => true,
    groups     => ['wheel'],
    password   => 'imademouser',
  }
}
