class profile::baseline {
  if $::kernel == 'Linux' {
    include profile::baseline::linux
  }
  elsif $::kernel == 'windows' {
    include profile::baseline::windows
  } 
}
