## site.pp ##

# This file (/etc/puppetlabs/puppet/manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition. (The default node can be omitted
# if you use the console and don't define any other nodes in site.pp. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.)

## Active Configurations ##

# Disable filebucket by default for all File resources:
File { backup => false }

# APP ORCHESTRATOR
# Applications managed by App Orchestrator are defined in the site block.

site {

  # rgbank { 'staging':
  #   web_count => 2,
  #   nodes     => {
  #     Node['rgbank-appserver-01.pdx.puppetlabs.demo']    => [
  #       Rgbank::Web['staging-0'],
  #     ],
  #     Node['rgbank-appserver-02.pdx.puppetlabs.demo']    => [
  #       Rgbank::Web['staging-1'],
  #     ],
  #     Node['rgbank-loadbalancer-01.pdx.puppetlabs.demo'] => [
  #       Rgbank::Load['staging'],
  #     ],
  #     Node['rgbank-database-01.pdx.puppetlabs.demo']     => [
  #       Rgbank::Db['staging'],
  #     ],
  #   },
  # }

  # rgbank { 'dev':
  #   nodes => {
  #     Node['rgbank-dev.pdx.puppetlabs.demo'] => [
  #       Rgbank::Web['dev-0'],
  #       Rgbank::Load['dev'],
  #       Rgbank::Db['dev'],
  #     ],
  #   },
  # }

#zabbix_app { 'single':
#    zabbix_server_fqdn => 'centos6a.pdx.puppetlabs.demo',
#    zabbix_web_fqdn    => 'centos6a.pdx.puppetlabs.demo',
#    database_name      => 'zbx',
#    database_user      => 'zabbix',
#    database_password  => 'zabbix1',
#    nodes              => {
#      Node['centos6a.pdx.puppetlabs.demo'] =>
#        [
#          Zabbix_app::Db['single'],
#          Zabbix_app::Web['single'],
#          Zabbix_app::Server['single']
#        ]
#    }
#  }
#
#zabbix_app { 'multi':
#    zabbix_server_fqdn => 'centos6c.pdx.puppetlabs.demo',
#    zabbix_web_fqdn    => 'centos6b.pdx.puppetlabs.demo',
#    database_name      => 'zbx',
#    database_user      => 'zabbix',
#    database_password  => 'zabbix1',
#    nodes              => {
#      Node['centos6b.pdx.puppetlabs.demo'] => Zabbix_app::Web['multi'],
#      Node['centos6c.pdx.puppetlabs.demo'] => Zabbix_app::Server['multi'],
#      Node['centos6d.pdx.puppetlabs.demo'] => Zabbix_app::Db['multi'],
#    }
#  }

}

# DEFAULT NODE
# Node definitions in this file are merged with node data from the console. See
# http://docs.puppetlabs.com/guides/language_guide.html#nodes for more on
# node definitions.

# The default node definition matches any node lacking a more specific node
# definition. If there are no other nodes in this file, classes declared here
# will be included in every node's catalog, *in addition* to any classes
# specified in the console for that node.

node default {
  # This is where you can declare classes for all nodes.
  # Example:
  #   class { 'my_class': }
}
