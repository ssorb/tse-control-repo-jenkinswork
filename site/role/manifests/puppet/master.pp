# The `puppetmaster` role sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class role::puppet::master {
  include profile::puppet::master
  include profile::puppet::rootenv
}
