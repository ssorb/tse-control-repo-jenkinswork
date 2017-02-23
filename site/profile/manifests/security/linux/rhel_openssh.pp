class profile::security::linux::rhel_openssh {

  $root = 'yes',
  ) {
  package { 'openssh-server':
    ensure => '5.3p1-84.1.el6',
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
