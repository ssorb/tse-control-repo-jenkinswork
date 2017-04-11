class profile::platform {

  case $::kernel {
    'Linux': { include profile::platform::linux }
    'windows': { include profile::platform::windows }
    default: { fail('unsupported operating system') }
  }

}
