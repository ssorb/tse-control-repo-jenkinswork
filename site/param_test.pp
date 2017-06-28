# param_test
class param_test (
  Optional[String] $splunk_server = undef,
){
  if $splunk_server == undef {
    notify { "This is my test value: UNDEF": }
  } else {
    notify { "This is my test value: $splunk_server": }
  }
}
