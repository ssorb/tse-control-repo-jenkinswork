class profile::baseline::linux::user {

  user { 'mike':
    ensure           => 'present',
    comment          => 'TSE Demo Account',
    gid              => '100',
    home             => '/',
    password         => 'puppetrocks!',
    shell            => '/sbin/bash',
    uid              => '1010',
  }

}
