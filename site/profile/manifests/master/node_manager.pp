class profile::master::node_manager {

  package { 'puppetclassify':
    ensure   => present,
    provider => puppet_gem,
  }

  Node_group {
    require => Package['puppetclassify'],
  }

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
      'ntp'             => {},
      'profile::pe_env' => {},
      'profile::repos'  => { 'offline' => false },
      'profile::vim'    => { 'colorscheme' => 'elflord' },
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

}
