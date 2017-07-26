# Requires rtyler/jenkins module
class profile::jenkins::server {

  class { 'jenkins':
    configure_firewall => true,
    direct_download    => 'http://pkg.jenkins-ci.org/redhat-stable/jenkins-2.7.4-1.1.noarch.rpm',
  }

  jenkins::user { 'root':
    email    => 'sailseng@example.com',
    password => 'puppetlabs',
  }

}
