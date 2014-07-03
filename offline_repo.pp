class offline_repo {

  package { 'yum-downloadonly':
    ensure => present,
  }
  package { 'createrepo':,
    ensure => present,
  }

  file { '/var/seteam-files/rpms':
    ensure => directory,
  }

  exec { 'yum_download':
    command => 'yum -y install tomcat6-docs-webapp tomcat6-webapps tomcat6 fontconfig dejavu-fonts-common java java-1.7.0-openjdk tomcat6-admin-webapps --downloadonly --downloaddir=/var/seteam-files/rpms',
    require => [
      Package['yum-downloadonly'],
      Package['createrepo'],
      File['/var/seteam-files/rpms'],
    ],
  }

  exec { 'createrepo':
    command => '/usr/bin/createrepo /var/seteam-files/rpms',
    require => Exec['yum_download'],
  }
}

include offline_repo
