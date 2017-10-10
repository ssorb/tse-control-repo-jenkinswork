class role::jenkins {

  class { 'profile::jenkins::server' :
#   gms_api_token      => 'et9FqxWxzkoF7GJXgqTQ',
   gitlab_domain      => 'gitlab.inf.puppet.vm',  
  }
  
  include profile::jenkins::jobs
  include profile::jenkins::plugins
}
