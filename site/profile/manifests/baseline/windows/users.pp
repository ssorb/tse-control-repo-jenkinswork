class profile::baseline::windows::users {

  # CUSTOM USERS
  user { 'Puppet Demo':
    ensure   => present,
    groups   => ['Administrators'],
  }

}
