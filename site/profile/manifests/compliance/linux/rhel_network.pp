class profile::compliance::linux::rhel_network {

  # creating a hash of all desired sysctl settings. This should make the data more readable.
  $sysctl_settings = {
                       'net.ipv4.conf.all.accept_source_route'     => { value => '0', },
                       'net.ipv4.conf.all.accept_redirects'        => { value => '0', },
                       'net.ipv4.conf.all.secure_redirects'        => { value => '0', },
                       'net.ipv4.conf.all.log_martians'            => { value => '1', },
                       'net.ipv4.conf.default.accept_source_route' => { value => '0', },
                       'net.ipv4.conf.default.accept_redirects'    => { value => '0', },
                       'net.ipv4.conf.default.secure_redirects'    => { value => '0', },
                       'net.ipv4.icmp_echo_ignore_broadcasts'      => { value => '1', },
#                       'net.ipv4.icmp_ignore_bogus_error_messages' => { value => '1', },
                       'net.ipv4.tcp_syncookies'                   => { value => '1', },
                       'net.ipv4.conf.all.rp_filter'               => { value => '1', },
                       'net.ipv4.conf.default.rp_filter'           => { value => '1', },
                     }

  # Setting the defaults used below
  $sysctl_defaults = {
    ensure    => present,
    permanent => 'yes',
  }

  # The create_resources function allows you to merge a hash into a series of functions. In this
  # example, the $sysctl_settings hash is being merged into the sysctl resource. This allows you
  # to avoid a large amount of repeated code, as well as making your class much more readable.
  # See http://docs.puppetlabs.com/references/latest/function.html#createresources for more details.
  create_resources(sysctl, $sysctl_settings, $sysctl_defaults)

}
