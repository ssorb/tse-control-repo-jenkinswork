class role::win_web_server {
  include dotnet
  include chocolatey
  include profile::windows::baseline
  include profile::windows::iis
  include cmsapp
}
