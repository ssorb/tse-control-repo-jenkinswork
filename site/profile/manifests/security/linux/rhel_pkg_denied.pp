class profile::security::linux::rhel_pkg_denied (
  $krb  = true,
  ) {

  $removed = [ 'telnet-server', 'telnet', 'rsh-server', 'rsh', 'tftp-server', 'talk-server', 'talk', 'anacron',
               'bind', 'vsftpd', 'dovecot', 'squid', 'net-snmpd' ]

  # Passing above array into the package function
  package { $removed:
    ensure => absent,
  }

  unless $krb {
    package { 'krb5-workstation': ensure => absent, }
  }
}
