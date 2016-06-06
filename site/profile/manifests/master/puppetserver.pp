# The `puppetmaster` profile sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class profile::master::puppetserver (
  String $demo_username = 'demo',
  String $demo_password = 'puppetlabs',
  String $demo_password_hash = '$1$Fq9vkV1h$4oMRtIjjjAhi6XQVSH6.Y.', #puppetlabs
  String $deploy_username = 'code_mgr_deploy_user',
  String $deploy_password = 'puppetlabs',
  String $deploy_key_dir = '/etc/puppetlabs/puppetserver/ssh',
  String $deploy_key_file = "${deploy_key_dir}/id-control_repo.rsa",
  String $deploy_token_dir = '/etc/puppetlabs/puppetserver/.puppetlabs',
  String $deploy_token_file = "${deploy_token_dir}/token",
  String $demo_home_dir = "/home/${demo_username}",
  String $demo_key_dir = "${demo_home_dir}/.ssh",
  String $demo_key_file = "${demo_key_dir}/id.rsa",
  String $demo_token_dir = "${demo_home_dir}/.puppetlabs",
  String $demo_token_file = "${demo_token_dir}/token",
  String $root_token_dir = '/root/.puppetlabs',
  String $root_token_file = "${root_token_dir}/token",
){
  include 'git'

  # Puppet master firewall rules
  Firewall {
    chain  => 'INPUT',
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '110 puppetmaster allow all': dport  => '8140';  }
  firewall { '110 console allow all':    dport  => '443';   }
  firewall { '110 mcollective allow all':  dport  => '61613'; }
  firewall { '110 pxp orch allow all':  dport  => '8142'; }

  ##################
  # Configure Puppet
  ##################

  class { 'hiera':
    datadir_manage => false,
    datadir        => '/etc/puppetlabs/code/environments/%{environment}/hieradata',
    hierarchy      => [
      'nodes/%{clientcert}',
      'environment/%{environment}',
      'datacenter/%{datacenter}',
      'virtual/%{virtual}',
      'common',
    ],
    eyaml          => true,
  }

  # We cannot simply set notify => Service['pe-puppetserver'] on Class['hiera']
  # because this profile is sometimes used by `puppet apply`, and other times
  # used in combination with pe-provided roles. So instead we'll collect the
  # service and add a subscribe relationship.
  Service <| title == 'pe-puppetserver' |> {
    subscribe => Class['hiera'],
  }

  # We have to manage this file like this because of ROAD-706
  $key = file('profile/license.key')
  exec { 'Create License':
    command => "/bin/echo \"${key}\" > /etc/puppetlabs/license.key",
    creates => '/etc/puppetlabs/license.key',
  }

  # generate keys and token for code manager deploys and demo user

  # The ssh-keygen command will fail if the destination dir does not exist, so must
  # manage it first. Opposite situation with puppet-access below.

  # deploy user's ssh keys
  file { $deploy_key_dir:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
  }

  exec { "create ${deploy_username} ssh key" :
    command => "/usr/bin/ssh-keygen -t rsa -b 2048 -C '${deploy_username}' -f ${deploy_key_file} -q -N ''",
    creates => $deploy_key_file,
    require => File[$deploy_key_dir],
  }

  # private key
  file { $deploy_key_file:
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    require => Exec["create ${deploy_username} ssh key"],
  }

  # public key
  file { "${deploy_key_file}.pub":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    require => Exec["create ${deploy_username} ssh key"],
  }

  # demo user's ssh keys
  file { $demo_key_dir:
    ensure => directory,
    owner  => $demo_username,
    group  => $demo_username,
    mode   => '0700',
    require => File[$demo_home_dir],
  }

  exec { "create ${demo_username} ssh key" :
    command => "/usr/bin/ssh-keygen -t rsa -b 2048 -C '${demo_username}' -f ${demo_key_file} -q -N ''",
    creates => $demo_key_file,
    require => File[$demo_key_dir],
  }

  # private key
  file { $demo_key_file:
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0600',
    require => Exec["create ${demo_username} ssh key"],
  }

  # public key
  file { "${demo_key_file}.pub":
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0644',
    require => Exec["create ${demo_username} ssh key"],
  }

  # copy of public key where profile::gitlab can grab it with file function
  file { "${deploy_key_dir}/demo_id.rsa.pub":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    source  => "${demo_key_file}.pub",
    require => File["${demo_key_file}.pub"],
  }

  # generate rbac roles and users for code manager deploys and demo user with ruby script
  $epp_params = {
    'deploy_username' => $deploy_username,
    'deploy_password' => $deploy_password,
    'demo_username'   => $demo_username,
    'demo_password'   => $demo_password
  }

  file {'/etc/puppetlabs/code/environments/production/scripts/create_demo_deploy_users.rb':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    content => epp('profile/create_demo_deploy_users.rb.epp', $epp_params),
  }

  exec { 'create code mgr deploy & demo group and user' :
    command     => '/opt/puppetlabs/puppet/bin/ruby /etc/puppetlabs/code/environments/production/scripts/create_demo_deploy_users.rb',
    refreshonly => true,
    subscribe   => File['/etc/puppetlabs/code/environments/production/scripts/create_demo_deploy_users.rb'],
  }

  # The puppet-access command will create any needed directories and make root their owner. So for the demo and deploy users we have to run the command
  # first and then manage the ownership later so pe-puppet can read during template file() function evaluation.
  exec { "create ${demo_username} rbac token" :
    command => "/bin/echo \"${demo_password}\" | /opt/puppetlabs/bin/puppet-access login --username ${demo_username} --service-url https://${clientcert}:4433/rbac-api --lifetime 1y --token-file ${demo_token_file}",
    creates => $demo_token_file,
    require => Exec['create code mgr deploy & demo group and user'],
  }

  user { $demo_username:
    ensure   => present,
    home     => $demo_home_dir,
    shell    => '/bin/bash',
    password => $demo_password_hash,
    require  => Exec["create ${demo_username} rbac token"],
  }

  file { $demo_home_dir:
    ensure  => directory,
    owner   => $demo_username,
    group   => $demo_username,
    require => User[$demo_username],
  }

  $profile = @("EOF")
    PS1='[\u@\h \W]\$ '
    echo "ensuring that ssh-agent is running to hold key for gitlab..."
    ssh-add -l &>/dev/null
    if [ "$?" == 2 ]; then
      test -r ~/.ssh-agent && \
        eval "$(<~/.ssh-agent)" >/dev/null

      ssh-add -l &>/dev/null
      if [ "$?" == 2 ]; then
        (umask 066; ssh-agent > ~/.ssh-agent)
        eval "$(<~/.ssh-agent)" >/dev/null
        echo "attempting to add private ssh key for gitlab..."
        ssh-add $demo_key_file
      fi
    fi
    | EOF

  file { "${demo_home_dir}/.profile":
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    content => $profile,
    require => File[$demo_home_dir],
  }

  file { $demo_token_dir:
    ensure  => directory,
    owner   => $demo_username,
    group   => $demo_username,
    require => File[$demo_home_dir],
  }

  file { $demo_token_file:
    ensure  => file,
    owner   => $demo_username,
    group   => $demo_username,
    mode    => '0600',
    require => Exec["create ${demo_username} rbac token"],
  }

  file { $root_token_dir:
    ensure  => directory,
    owner   => root,
    group   => root,
    require => Exec["create ${demo_username} rbac token"],
  }

  file { $root_token_file:
    ensure => link,
    target => $demo_token_file,
  }

  exec { "create ${deploy_username} rbac token" :
    command => "/bin/echo \"${deploy_password}\" | /opt/puppetlabs/bin/puppet-access login --username ${deploy_username} --service-url https://${clientcert}:4433/rbac-api --lifetime 1y --token-file ${deploy_token_file}",
    creates => $deploy_token_file,
    require => Exec['create code mgr deploy & demo group and user'],
  }
 
  file { $deploy_token_dir:
    ensure  => directory,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0700',
    require => Exec["create ${deploy_username} rbac token"],
  }

  file { $deploy_token_file:
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    require => Exec["create ${deploy_username} rbac token"],
  }

}
