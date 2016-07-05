class role::rgbank::appserver {
  include profile::firewall
  include profile::orchestrator_client
  include profile::rgbank::appserver
}
