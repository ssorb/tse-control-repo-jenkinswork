class profile::master::node_manager {

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
  }

  Node_group {
    require => Package['puppetclassify'],
  }

  # GENERAL PURPOSE
  # Node Groups ready to go out of the box. Not tied to any specific demo, but
  # potentially useful for demonstrating the Node Manager in general.

  node_group { 'PE Master':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', $::clientcert]],
    classes              => {
      'ldap'                                             => {},
      'ntp'                                              => {},
      'pe_repo'                                          => {},
      'pe_repo::platform::el_6_x86_64'                   => {},
      'pe_repo::platform::el_7_x86_64'                   => {},
      'pe_repo::platform::ubuntu_1204_amd64'             => {},
      'pe_repo::platform::ubuntu_1404_amd64'             => {},
      'pe_repo::platform::windows_x86_64'                => {},
      'puppet_enterprise::profile::master'               => {},
      'puppet_enterprise::profile::master::mcollective'  => {},
      'puppet_enterprise::profile::mcollective::peadmin' => {},
      'role::master'                                     => {},
      'profile::vim'                                     => { 'colorscheme' =>'elflord' },
    },
  }

  node_group { 'Linux Servers':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and',
      ['not', ['=', ['fact', 'name'], $::clientcert]],
      ['=', ['fact', 'kernel'], 'Linux'],
    ],
    classes              => {
      'ntp'                      => {},
      'profile::puppet::rootenv' => {},
      'profile::patch::pup_5595' => {},
      'profile::repos'           => { 'offline' => false },
      'profile::vim'             => { 'colorscheme' => 'elflord' },
    },
  }

  node_group { 'Windows Servers':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => ['and', ['=', ['fact', 'kernel'], 'windows']],
    classes              => {
      'profile::windows::chocolatey' => {},
      'profile::patch::pup_5595' => {},
    },
  }

  node_group { 'PE MCollective':
    ensure               => present,
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['and',
      ['=', ['fact', 'is_admin'], 'true'],
      ['~', ['fact', 'aio_agent_version'], '.+'],
    ],
    classes              => {
      'puppet_enterprise::profile::mcollective::agent' => {},
    },
  }

  # RGBANK DEMO
  # Node groups and rbac users specific to the rgbank demo.

  rbac_user { 'joe':
    ensure       => 'present',
    name         => 'joe',
    display_name => 'Joe Black',
    email        => 'joe@puppetlabs.com',
    password     => 'puppetlabs',
  }

  node_group { 'rgbank / Load Balancers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'All Nodes',
    rule        => ['or',
      ['~', 'name', '^rgbank-loadbalancer-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'haproxy'                      => {},
      'profile::firewall'            => {},
      'profile::orchestrator_client' => {},
    }
  }

  node_group { 'rgbank / App Servers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'All Nodes',
    rule        => ['or',
      ['~', 'name', '^rgbank-appserver-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'mysql::bindings::php'         => {},
      'mysql::client'                => {},
      'apache'                       => { 'default_vhost' => false },
      'apache::mod::php'             => {},
      'git'                          => {},
      'profile::firewall'            => {},
      'profile::orchestrator_client' => {},
    },
  }

  node_group { 'rgbank / Database Servers':
    ensure      => 'present',
    environment => 'production',
    parent      => 'All Nodes',
    rule        => ['or',
      ['~', 'name', '^rgbank-database-.*'],
      ['~', 'name', '^rgbank-dev.*'],
    ],
    classes     => {
      'mysql::server' => {
        'override_options' => { 'mysqld' => { 'bind-address' => '0.0.0.0' } },
      },
      'git'                          => {},
      'profile::firewall'            => {},
      'profile::orchestrator_client' => {},
    },
  }

}
