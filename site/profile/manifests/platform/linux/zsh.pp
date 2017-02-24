class profile::platform::linux::zsh {
  include ohmyzsh
  ohmyzsh::install { ['root']: }
  ohmyzsh::theme { ['root']: theme => clean }
  ohmyzsh::plugins { ['root']: plugins => 'git github' }
  contain git
  Class['git'] -> Class['ohmyzsh']
  file {'/etc/zsh':
    ensure => directory,
  }
  file {'/etc/zsh/zprofile':
    ensure => file,
  }
  file_line { 'emulate profile.d':
    path => '/etc/zsh/zprofile',
    line => 'emulate sh -c \'source /etc/profile\'',
  }
  User{
    require => Package['zsh'],
  }
}
