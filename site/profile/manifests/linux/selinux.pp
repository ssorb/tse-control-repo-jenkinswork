class profile::linux::selinux {
  include stdlib

  class { 'selinux':
    mode  => 'disabled',
    stage => 'setup',
  }

  reboot { 'selinux':
    apply     => finished,
    subscribe => Class['selinux'],
  }

}
