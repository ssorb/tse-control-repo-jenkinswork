class profile::platform::linux {

  include profile::platform::linux::motd
  include profile::platform::linux::vim
  include profile::platform::linux::ssh
  #include profile::baseline::linux::zsh
  include profile::platform::linux::user

}
