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

  exec {'fix perms':
    command => "chown -R jenkins:jenkins ${jenkins_path} *",
    creates     => '/tmp/fix-perms',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive[$docs_gz_path],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }     

  exec { 'jenkins restart':
    command     => 'systemctl restart jenkins',
    creates     => '/tmp/restart-jenkins',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive[$docs_gz_path],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }

  jenkins::user { 'admin':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }  
  
  package { 'nmap':
    ensure => installed,
  }  
 
  user { 'ec2-user':
    ensure   => present,
    groups    => ['docker'],
  }
  
  exec { "create ssh key for jenkins user":
    cwd         => "${jenkins_path}",
    command     => 'ssh-keygen -t rsa -b 4096 -C \'your_email@example.com\' -N \'\' -f id_rsa',
    user        => "jenkins",
    environment => ["HOME=${jenkins_path}"],
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
