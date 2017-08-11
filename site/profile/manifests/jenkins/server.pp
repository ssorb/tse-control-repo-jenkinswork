# Requires rtyler/jenkins module
class profile::jenkins::server (
  Optional[String] $gms_api_token    = hiera('gms_api_token', undef),
  Optional[String] $gms_server_url   = hiera('gms_server_url', undef),
 ){
  
  $jenkins_path     = '/var/lib/jenkins'
  $jenkins_service_user      = 'jenkins_service_user'
  $token_directory  = "${jenkins_path}/.puppetlabs"
  $token_filename   = "${token_directory}/${$jenkins_service_user}_token"
  $jenkins_service_user_password = fqdn_rand_string(40, '', "${jenkins_service_user}_password")
  $jenkins_ssh_key_directory   = "${jenkins_path}/.ssh"
  $jenkins_ssh_key_file_name = 'id-control_repo.rsa'
  $jenkins_ssh_key_file = "${jenkins_ssh_key_directory}/${jenkins_ssh_key_file_name}"
  $git_management_system     = 'github'
  $jenkins_role_name         = 'Code Deployers'
  $control_repo_project_name = 'puppet/control-repo'

# Generate ssh key for jenkins user
  file { $jenkins_ssh_key_directory:
    ensure  => directory,
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
  }  
  
  exec { 'create ssh key for jenkins user':
    cwd         => $jenkins_ssh_key_directory,
    command     => "/bin/ssh-keygen -t rsa -b 4096 -C 'jenkins' -f ${jenkins_ssh_key_file} -q -N '' && ssh-keyscan gitlab.inf.puppet.vm >> ~/.ssh/known_hosts",
    user        => 'jenkins',
    environment => ["HOME=${jenkins_path}"],
     require => File[ "${jenkins_path}/.ssh/"],
  }  
  
# create rbac user for jenkins 
  rbac_user { $jenkins_service_user :
    ensure       => 'present',
    name         => $jenkins_service_user,
    email        => "${jenkins_service_user}@example.com",
    display_name => 'Jenkins Service Account',
    password     => $jenkins_service_user_password,
    roles        => [ $jenkins_role_name ],
  }

  file { $token_directory :
    ensure => directory,
    owner  => 'jenkins',
    group  => 'jenkins',
  }

  exec { "Generate Token for ${jenkins_service_user}" :
    command => epp('profile/jenkins/create_rbac_token.epp',
                  { 'jenkins_service_user'          => $jenkins_service_user,
                    'jenkins_service_user_password' => $jenkins_service_user_password,
                    'classifier_hostname'           => 'master.inf.puppet.vm',
                    'classifier_port'               => '4433',
                    'token_filename'                => $token_filename
                  }),
    creates => $token_filename,
    require => [ Rbac_user[$jenkins_service_user], File[$token_directory] ],
  }  
  
# Include docker, wget, git, and apache (generic website)
  include wget
  include docker
  include git  
  include profile::app::generic_website::linux

# add gitlabd and centos-7-3 to hosts file
  host { 'gitlab.inf.puppet.vm':
    ip           => '192.168.0.95',
    host_aliases => 'gitlab',
  }
  
  host { 'centos-7-3.pdx.puppet.vm':
    ip           => '192.168.0.102',
    host_aliases => 'centos-7-3',
  }  

#install java
  java::oracle { 'jdk8' :
    ensure        => 'present',
    url_hash      => 'd54c1d3a095b4ff2b6607d096fa80163',
    version_major => '8u131',
    version_minor => 'b11',
    java_se       => 'jdk',
  }

# install jenkins
  class { 'jenkins':
    configure_firewall => true,
    direct_download    => 'http://pkg.jenkins-ci.org/redhat/jenkins-2.62-1.1.noarch.rpm',
    require            => Java::Oracle['jdk8'],
  }

#unpack pre-baked jenkins config data
  archive {  "${jenkins_path}/xmls.tar.gz":
    source        => 'puppet:///modules/profile/xmls.tar.gz',
    extract       => true,
    extract_path  => $jenkins_path,
    creates       => "/tmp/xmls-file", #directory inside tgz
    require       => [ Class['jenkins'] ],
  }

#set up pipeline
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

# Set up artifact repository
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

# Make sure all the files in /var/lib/jenks are owned by jenkins:jenkins
  exec {'fix perms':
    command => "chown -R jenkins:jenkins ${jenkins_path} *",
    creates     => '/tmp/fix-perms',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive["${jenkins_path}/xmls.tar.gz"],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }     

# restart jenkins
  exec { 'jenkins restart':
    command     => 'systemctl restart jenkins',
    creates     => '/tmp/restart-jenkins',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  [ Archive["${jenkins_path}/xmls.tar.gz"],File["${jenkins_path}/jobs/Pipeline/config.xml"], Class['jenkins'] ],
  }
  
# restart docker  
  exec { 'docker restart':
    command     => 'systemctl restart docker',
    creates     => '/tmp/restart-docker',
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    require =>  Exec['jenkins restart'],
  }
  
# create jenkins user admin  
  jenkins::user { 'admin':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }  
  
#  Add jenkins user to docker group
  exec { "add jenkins user to docker group":
    command => '/sbin/usermod -a -G docker jenkins',
    creates => '/tmp/usermod-perms',
    require => Class['jenkins']
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
