class role::jenkins {

  class { 'profile::jenkins::server' :
   gms_api_token      => 'et9FqxWxzkoF7GJXgqTQ',
   gitlab_domain      => 'gitlab.inf.puppet.vm',  
   gitlab_ip          => '192.168.0.95',   
   prod_deploy_domain => 'javaappserver.puppet.pdx.vm',  
   prod_deploy_ip     => '192.168.0.102',         
  }
  
  include profile::jenkins::jobs
  include profile::jenkins::plugins
}
