#
class profile::windows::desktop_baseline {

  Package {
    ensure   => latest,
    provider => chocolatey,
    notify   => Reboot['after_run'],
  }

  package { 'jre8': }

  package { 'flashplayerplugin':}

  package { 'adobereader':}

  package { 'googlechrome':}

  package { 'notepadplusplus':
    ensure   => '7.3',
    provider => 'chocolatey',
  }

  package {'launchy':
    install_options => ['-override', '-installArgs', '"', '/VERYSILENT', '/NORESTART', '"'],
  }

# Reboot machine after packages are installed.
  reboot { 'after_run':
    apply  => finished,
  }

# Create Corporate Admin user
  user { 'Corp Admin':
    ensure => present,
    groups => ['Administrators'],
  }

# Make sure firewall is turned on
  class { 'windows_firewall':
    ensure => 'running'
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
