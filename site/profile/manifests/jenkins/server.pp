# Requires rtyler/jenkins module
class profile::jenkins::server {

  include wget

  java::oracle { 'jdk8' :
    ensure        => 'present',
    url_hash      => 'd54c1d3a095b4ff2b6607d096fa80163',
    version_major => '8u131',
    version_minor => 'b11',
    java_se       => 'jdk',
  }

  class { 'jenkins':
    configure_firewall => true,
    direct_download    => 'http://pkg.jenkins-ci.org/redhat-stable/jenkins-2.60.2-1.1.noarch.rpm',
    require            => Java::Oracle['jdk8'],
  }

  
  jenkins::user { 'admin':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }  
  
  package { 'nmap':
    ensure => installed,
  }  
  
#  include 'docker'
#  include 'git'
  
#  package { 'git':
#    ensure => installed,
#  }
  
#  class { 'docker':
#    require => Class['jenkins'],
#  }
  
#  # Start docker  service
#  service { 'docker':
#    ensure  => 'running',
#  }

  # Start jenkins service
#  service { 'jenkins':
#    ensure  => 'running',
#  }
  
  user { 'ec2-user':
    ensure   => present,
    groups    => ['docker'],
  }
  
#  user { 'jenkins':
#    ensure   => present,
#    groups    => ['docker'],    
#  }  
  
 # Install Maven
class { "maven::maven":
  version => "3.0.5", # version to install
} 

}
