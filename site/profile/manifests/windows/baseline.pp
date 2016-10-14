class profile::windows::baseline {

  # PACKAGES
  Package {
    ensure   => installed,
    provider => chocolatey,
  }
  
  package { 'Firefox': }
  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }

  # FIREWALL
  windows_firewall::exception { 'TSErule':
    ensure       => present,
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '8080',
    display_name => 'TSE PUPPET DEMO',
    description  => 'Inbound rule example for demo purposes',
  }

  # USERS
  user { 'Puppet Demo':
    ensure   => present,
    groups   => ['Administrators'],
  }

  # REG KEYS
  registry_key { 'HKEY_LOCAL_MACHINE\Software\Demonstration':
    ensure       => present,
    purge_values => true,
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value1':
    type => string,
    data => 'this is a value new from puppet intro',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value2':
    type         => dword,
    data         => '0xFFFFFFFF',
  }

}
