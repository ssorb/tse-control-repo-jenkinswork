# Requires rtyler/jenkins module
class profile::jenkins::server {

  # This script is created by puppet to update admin password
  $jenkins_update_pass_script = '/usr/local/sbin/jenkins-ssh-key-to-user.sh'

  # Path to store  jenkins SSH private and public key - used to communicate with jenkinscli
  $jenkins_ssh_key_admin = '/root/jenkins_ssh_key_admin'

  # Path where admin user have config in jenkins home dir.
  $jenkins_admin_user_config = '/var/lib/jenkins/users/admin/config.xml'


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
    cli_ssh_keyfile => $jenkins_ssh_key_admin,    
    direct_download    => 'http://pkg.jenkins-ci.org/redhat/jenkins-2.62-1.1.noarch.rpm',
    require            => Java::Oracle['jdk8'],
  }

  file { $jenkins_update_pass_script:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => "#!/bin/bash
for i in $(seq 1 60); do [[ -e ${jenkins_admin_user_config} ]] && break; sleep 1s; done

sed -i '/<\\/\\(user\\|properties\\)>/d' ${jenkins_admin_user_config}
cat<<EOF >> ${jenkins_admin_user_config}
    <org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
        <authorizedKeys>`cat ${jenkins_ssh_key_admin}.pub`</authorizedKeys>
    </org.jenkinsci.main.modules.cli.auth.ssh.UserPropertyImpl>
  </properties>
  </user>
EOF"
  }
  
  exec { 'admin-ssh-key':
    command   => "ssh-keygen -f '${jenkins_ssh_key_admin}' -N '' && ${jenkins_update_pass_script}",
    creates   => $jenkins_ssh_key_admin,
    path      => [ '/bin', '/usr/bin/', '/usr/local/sbin' ],
    require   => File[$jenkins_update_pass_script],
    subscribe => Package['jenkins'],
    before    => Class['jenkins::cli'],
  }
  

#  class { jenkins::security:
#    security_model => 'full_control',
#  }

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
