# Requires rtyler/jenkins module
class profile::jenkins::server {

  $docs_filename = 'xmls.tar.gz'
  $docs_gz_path  = "/tmp/${docs_filename}"
  $jenkins_path  = '/var/lib/jenkins'

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
    direct_download    => 'http://pkg.jenkins-ci.org/redhat/jenkins-2.62-1.1.noarch.rpm',
    require            => Java::Oracle['jdk8'],
  }

#  class { jenkins::security:
#    security_model => 'full_control',
#  }

  file {$docs_gz_path:
    ensure => file,
    source => "puppet:///modules/profile/${docs_filename}",
  }

  archive { $docs_gz_path:
    path          => $docs_gz_path,
    #cleanup       => true, # Do not use this argument with this workaround for idempotency reasons
    extract       => true,
    extract_path  => $jenkins_path,
    creates       => "/tmp/xmls-file", #directory inside tgz
    require       => [ File[$docs_gz_path],Class['jenkins'] ],
  }

  file { '/var/lib/jenkins/jobs/Pipeline/':
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
    require => Class['jenkins']
  }

  file { '/var/lib/jenkins/jobs/Pipeline/config.xml':
    ensure  => file,  
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => 'puppet:///modules/profile/PipelineConfig.xml',
    mode    => '0755',
    require => File['/var/lib/jenkins/jobs/Pipeline/']
  }

  exec { 'jenkins restart':
    command     => 'systemctl jenkins restart',
    creates     => '/tmp/restart-jenkins',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
    require => File['/var/lib/jenkins/jobs/Pipeline/config.xml']
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
