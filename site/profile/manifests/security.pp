class profile::security {

  case $::osfamily {
    'RedHat': { include profile::security::linux_rhel }
    'windows': { include profile::security::windows }
    default: { fail('unsupported operating system') }
  }

}
