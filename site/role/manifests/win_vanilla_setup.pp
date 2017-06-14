#
class role::win_vanilla_setup {
  include profile::windows::baseline
  include profile::windows::local_policy 
  include profile::compliance::windows::cis
}