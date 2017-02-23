class profile::baseline {

  case $::kernel {
    'Linux': { include profile::baseline::linux }
    'windows': { include profile::baseline::windows }
    default: { fail('unsupported operating system') }
  }

}
