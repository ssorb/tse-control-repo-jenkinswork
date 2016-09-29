class role::rgbank::app {
  include profile::firewall
  include profile::linux::selinux
  include profile::orchestrator_client
  include profile::rgbank::appserver
}
