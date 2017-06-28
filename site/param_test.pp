# param_test
class param_test (
  Optional[String] $splunk_server = undef,
){
  if $splunk_server == undef {
    $splunk_nodes_query = 'resources[certname] { type = "Class" and title = "Apache" }'
    $splunk_server = puppetdb_query($splunk_nodes_query)[0][certname]
  }
  notify { "This is my test value: $splunk_server": }
}
