class profile::windows::chocolatey (
  $chocolatey_download_url = undef,
) {

  class { 'chocolatey':
    chocolatey_download_url => $chocolatey_download_url,
  }

  require profile::windows::dotnet

  Class['profile::windows::dotnet'] -> Class['chocolatey']

}
