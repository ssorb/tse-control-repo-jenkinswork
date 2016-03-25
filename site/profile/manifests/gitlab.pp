class profile::gitlab {

  #Configure iptables
  service { 'firewalld':
    ensure => stopped,
    enable => false,
  }

  package { 'iptables-services':
    ensure => installed,
  }

  service { ['iptables', 'ip6tables']:
    ensure => running,
    enable => true,
  }

  firewall { '100 allow https':
    proto  => 'tcp',
    dport  => '443',
    action => 'accept',
  }

  #Install gitlab
  file { ['/etc/gitlab', '/etc/gitlab/ssl'] :
    ensure => directory,
  }

  file { "/etc/gitlab/ssl/${::fqdn}.key" :
    ensure => file,
    source => "${::settings::privatekeydir}/${::trusted['certname']}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  file { "/etc/gitlab/ssl/${::fqdn}.crt" :
    ensure => file,
    source => "${::settings::certdir}/${::trusted['certname']}.pem",
    notify => Exec['gitlab_reconfigure'],
  }

  class { 'gitlab':
    external_url => hiera( 'gms_server_url', "https://${::fqdn}") ,
    require      => File["/etc/gitlab/ssl/${::fqdn}.key", "/etc/gitlab/ssl/${::fqdn}.key"],
  }

  #Initialize gitlab
  file { '/etc/gitlab/init.sh':
    ensure  => file,
    mode    => '0700',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/profile/gitlab-init.sh',
    require => Class['gitlab'],
  }
  exec { '/etc/gitlab/init.sh && touch /etc/gitlab/init':
    creates => '/etc/gitlab/init',
    require => File['/etc/gitlab/init.sh'],
  }

}
