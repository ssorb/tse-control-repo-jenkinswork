# Requires rtyler/jenkins module
class profile::jenkins::server {

  java::oracle { 'jdk8' :
    ensure        => 'present',
    url_hash      => 'd54c1d3a095b4ff2b6607d096fa80163',
    version_major => '8u131',
    version_minor => 'b11',
    java_se       => 'jdk',
  }

  class { 'jenkins':
    configure_firewall => true,
    direct_download    => 'http://pkg.jenkins-ci.org/redhat-stable/jenkins-2.7.4-1.1.noarch.rpm',
    require            => Java::Oracle['jdk8'],
  }

  jenkins::user { 'root':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }
  
#  include 'docker'
#  include 'git'
  
#  package { 'git':
#    ensure => installed,
#  }
  
#  class { 'docker':
#    require => Class['jenkins'],
#  }
  
  # Start docker  service
  service { 'docker':
    ensure  => 'running',
    require => Class['docker'],
  }

  # Start jenkins service
  service { 'jenkins':
    ensure  => 'running',
    require => Class['docker'],
  }
  
  user { 'ec2-user':
    ensure   => present,
    group    => ['docker'],
  }
  
  user { 'jenkins':
    ensure   => present,
    group    => ['docker'],    
  }  
  
  class { '::maven':
    package_ensure  => '3.0.5'
  }

}
