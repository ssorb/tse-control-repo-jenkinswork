class profile::baseline::windows {

  include profile::baseline::windows::packages
  include profile::baseline::windows::registry
  include profile::baseline::windows::firewall_rules
  include profile::baseline::windows::users

}
