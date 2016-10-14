class role::rgbank::loadbalancer {
  include haproxy
  include profile::firewall
  include profile::orchestrator_client
  include profile::linux::selinux
}
