class profile::platform::windows {

  include profile::platform::windows::packages
  include profile::platform::windows::registry
  include profile::platform::windows::firewall_rules
  include profile::platform::windows::users

}
