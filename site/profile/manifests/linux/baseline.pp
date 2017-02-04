class profile::linux::baseline {
  package { 'unzip':
    ensure => installed,
  }

  # USERS
  if $::operatingsystem == 'CentOS' {
    user { 'PuppetDemo':
      ensure     => present,
      managehome => true,
      groups     => ['wheel'],
      comment    => 'user for CentOS',
    }

  }
  elsif $::operatingsystem == 'Ubuntu' {
    user { 'PuppetDemo':
      ensure     => present,
      managehome => true,
      groups     => ['sudo'],
      password   => 'user for Ubuntu',
    }
  }
}
