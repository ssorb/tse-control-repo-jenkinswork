class profile::compliance::linux::rhel_openssh (
  $root = 'yes',
  ) {

  case $::operatingsystemmajrelease {
    '6': { $openssh_version = '5.3p1-112.el6_7' }
    '7': { $openssh_version = '6.6.1p1-22.el7' }
    default: { fail('unsupported operating system') }
  }

  package { 'openssh-server':
    ensure => $openssh_version,
    before => File['/etc/ssh/sshd_config'],
  }

  file { '/etc/issue':
    ensure => file,
    content => template('profile/openssh/banner.erb'),
  }

  # The $root parameter is being passed to the template to enable toggling of root logins
  file { '/etc/ssh/sshd_config':
    ensure => file,
    content => template('profile/openssh/sshd_config.erb'),
  }

  service { 'sshd':
    ensure    => 'running',
    enable   => true,
    subscribe => File['/etc/ssh/sshd_config'],
  }

}
