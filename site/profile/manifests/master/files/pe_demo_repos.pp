class profile::master::files::pe_demo_repos {

  # Creates and serves a tarball containing all of the git repositories used to
  # bootstrap the master. This will be consumed later by a gitlab server when
  # it is configured.
  exec { "repos tarball" :
    cwd     => "/opt/puppetlabs",
    command => "/bin/tar -czf /opt/tse-files/pe-demo-repos.tar.gz repos",
    creates => "/opt/tse-files/pe-demo-repos.tar.gz",
    require => Class['profile::master::fileserver'],
  }

}
