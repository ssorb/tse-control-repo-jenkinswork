class role::rgbank::database {
  include git
  include profile::firewall
  include profile::orchestrator_client

  class { 'mysql::server':
    override_options => { 'mysqld' => { 'bind-address' => '0.0.0.0' } },
  }
}
