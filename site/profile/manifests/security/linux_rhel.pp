class profile::security::linux_rhel {

  include profile::security::linux::rhel_network
  include profile::security::linux::rhel_openssh
  include profile::security::linux::rhel_pkg_denied
  include profile::security::linux::rhel_svc_denied

}
