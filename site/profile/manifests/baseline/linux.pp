class profile::baseline::linux {

  include profile::baseline::linux::motd
  include profile::baseline::linux::vim
  include profile::baseline::linux::ssh
  include profile::baseline::linux::zsh
  include profile::baseline::linux::user

}
