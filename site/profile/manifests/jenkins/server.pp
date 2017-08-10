# Requires rtyler/jenkins module
class profile::jenkins::server {

  $jenkins_path  = '/var/lib/jenkins'

  include wget
  include docker
  include git  
  include profile::app::generic_website::linux

  host { 'gitlab.inf.puppet.vm':
    ip           => '192.168.0.95',
    host_aliases => 'gitlab',
  }
  
  host { 'centos-7-3.pdx.puppet.vm':
    ip           => '192.168.0.102',
    host_aliases => 'centos-7-3',
  }  

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

#  file {$docs_gz_path:
#    ensure => file,
#    source => "puppet:///modules/profile/${docs_filename}",
#  }

  archive {  "${jenkins_path}/xmls.tar.gz":
    source        => 'puppet:///modules/profile/xmls.tar.gz',
    extract       => true,
    extract_path  => $jenkins_path,
    creates       => "/tmp/xmls-file", #directory inside tgz
    require       => [ Class['jenkins'] ],
  }

  file { "${jenkins_path}/jobs/Pipeline/":
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
    require => Class['jenkins']
  }

  file { "${jenkins_path}/jobs/Pipeline/config.xml":
    ensure  => file,  
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => 'puppet:///modules/profile/PipelineConfig.xml',
    mode    => '0755',
    require => File["${jenkins_path}/jobs/Pipeline/"],
  }
  
  file { "${jenkins_path}/.openstack_snapshotrc":
    ensure  => file,  
    owner   => 'jenkins',
    group   => 'jenkins',
    source  => 'puppet:///modules/profile/openstack_snapshotrc',
    mode    => '0755',
    require => Class['jenkins'],
  }  
  
  file { "${jenkins_path}/workspace/":
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
  }
  
  file { "${jenkins_path}/workspace/Pipeline/":
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
    require =>  File["${jenkins_path}/workspace/"]
  }  

  file { '/var/www/generic_website/artifacts':
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0777',
  }

# fpm dependencies
  $enhancers = [ 'ruby-devel', 'gcc', 'make', 'rpm-build', 'rubygems' ]
  package { $enhancers: 
    ensure => 'installed',
    provider => 'yum'
  }
  
  package { 'fpm':
    ensure   => 'installed',
    provider => 'gem',
    install_options => [ '--no-ri', '--no-rdoc' ],
    require =>  Package[$enhancers]    
  }

#  class { 'python' :
#    version    => 'python34',
#    pip        => 'present',
#    dev        => 'present',
#    virtualenv => 'absent',
#    gunicorn   => 'absent',
#  }

#  $pips = [ 'python-keystoneclient', 'python-novaclient']  
#  package { $pips:
#    ensure => present,
#    provider => 'pip',
#    require => Package[$enhancers] ,    
#  } 

  exec {'fix perms':
    command => "chown -R jenkins:jenkins ${jenkins_path} *",
    creates     => '/tmp/fix-perms',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive["${jenkins_path}/xmls.tar.gz"],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }     

  exec { 'jenkins restart':
    command     => 'systemctl restart jenkins',
    creates     => '/tmp/restart-jenkins',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive["${jenkins_path}/xmls.tar.gz"],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }
  
  exec { 'docker restart':
    command     => 'systemctl restart docker',
    creates     => '/tmp/restart-docker',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  Exec['jenkins restart'],
  }
  
  jenkins::user { 'admin':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }  
  
#  package { 'nmap':
#    ensure => installed,
#  }  
 
  exec { "add jenkins user to docker group":
    command => '/sbin/usermod -a -G docker jenkins',
    creates => '/tmp/usermod-perms',
    require => Class['jenkins']
  } 
  
  # Generate ssh key for jenkins user
  file { "${jenkins_path}/.ssh/":
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
  }  
  
  exec { "create ssh key for jenkins user":
    cwd         => "${jenkins_path}/.ssh",
    command     => '/bin/ssh-keygen -t rsa -b 4096 -C \'your_email@example.com\' -N \'\' -f id_rsa',
    user        => 'jenkins',
    environment => ["HOME=${jenkins_path}"],
     require => File[ "${jenkins_path}/.ssh/"],
  }
  
 # Install Maven
  class { 'maven::maven':
    version => "3.0.5", # version to install
  } 
  
  file { '/usr/local/apache-maven':
    ensure  => 'link',
    target  => '/opt/apache-maven-3.0.5',
    require => Class['maven::maven'],
  }

}
