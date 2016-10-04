class profile::windows::baseline_dsc {

  # NOTE this requires powershell5, please use the powershell5 module to update.  It will reboot the machine without asking.

  #Features
  dsc_windowsfeature{'iis':
      dsc_ensure => 'Present',
      dsc_name => 'Web-Server',
  }
  dsc_windowsfeature{'iisconsole':
      dsc_ensure => 'present',
      dsc_name => 'Web-Mgmt-Console',
  }
  dsc_windowsfeature{'aspnet45':
      dsc_ensure => 'Present',
      dsc_name => 'Web-Asp-Net45',
  }
  
  # PACKAGES
  Package {
    ensure   => installed,
    provider => chocolatey,
  }
  package { 'Firefox': }
  package { 'notepadplusplus': }
  package { '7zip': }
  package { 'git': }
  
  windows_java::jdk{'7u51':
    install_path => 'C:\java\jdk7u51',
    default      => false,
  }

  #  Setup sample share
  file { 'c:\shares':
    ensure => 'directory',
  }
  acl { 'c:\shares':
    permissions => [
     { identity => 'Administrators', rights => ['full'] },
     { identity => 'Users', rights => ['read','execute'] }
    ],
    owner       => 'Administrators',
    inherit_parent_permissions => 'true',
    before  =>  Dsc_xsmbshare["Shares Root"],
  }
  dsc_xsmbshare { 'Shares Root':
    dsc_ensure     => 'present',
    dsc_name       => 'SharesRoot',
    dsc_path       => 'c:\shares',
    dsc_fullaccess => ["everyone","${::hostname}\vagrant"],
    dsc_folderenumerationmode => "Unrestricted",
  }

  # FIREWALL
  dsc_xservice { 'firewall':
    dsc_name         => "MpsSvc",
    dsc_state        => running,
    dsc_displayname  => "Windows Firewall",
    dsc_builtinaccount => "LocalService",
  }
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
    ensure => present,
    groups => ['Administrators'],
  }

   # REG KEYS
  registry_key { 'HKEY_LOCAL_MACHINE\Software\Demonstration':
    ensure       => present,
    purge_values => true,
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value1':
    type => string,
    data => 'this is a value',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Demonstration\value2':
    type         => dword,
    data         => '0xFFFFFFFF',
  }

}
