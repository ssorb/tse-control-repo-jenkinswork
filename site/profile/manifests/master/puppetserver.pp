# The `puppetmaster` profile sets up a master system, synchronizes files from
# Amazon, and generally enables SE Team specific patterns dependent on master
# capabilities.
#
class profile::master::puppetserver (
  String $key_dir = '/etc/puppetlabs/puppetserver/ssh',
  String $key_file = "${key_dir}/id-control_repo.rsa",
  String $deploy_token_dir = '/etc/puppetlabs/puppetserver/.puppetlabs',
  String $deploy_token_file = "${deploy_token_dir}/token",
  String $demo_token_dir = '/root/.puppetlabs',
  String $demo_token_file = "${demo_token_dir}/token",
  String $deploy_username = 'code_mgr_deploy_user',
  String $deploy_password = 'puppetlabs',
  String $demo_username = 'demo',
  String $demo_password = 'puppetlabs',
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

  # SET-84 Turn off Dujour / telemetry for demo env for 2015.2
  file { '/etc/puppetlabs/puppetserver/opt-out':
    ensure => file,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

  # generate keys and token for code manager deploys

  # The ssh-keygen command will fail if the destination dir does not exist, so must
  # manage it first. Opposite situation with puppet-access below.
  file { $key_dir:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
  }

  exec { "create ${deploy_username} ssh key" :
    command => "/usr/bin/ssh-keygen -t rsa -b 2048 -C '${deploy_username}' -f ${key_file} -q -N ''",
    creates => $key_file,
    require => File[$key_dir],
  }

  # private key
  file { $key_file:
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    require => Exec["create ${deploy_username} ssh key"],
  }

  # public key
  file { "${key_file}.pub":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    require => Exec["create ${deploy_username} ssh key"],
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
    command     => '/opt/puppetlabs/puppet/bin/ruby /etc/puppetlabs/code/environments/production/scripts/create_code_mgr_deploy_user.rb',
    refreshonly => true,
    subscribe   => Exec["create ${deploy_username} ssh key"],
  }

  # The puppet-access command will create any needed directories and make root their owner. So for the deploy user we have to run the command
  # first and then manage the ownership later so pe-puppet can read during template file() function evaluation.
  exec { "create ${demo_username} rbac token" :
    command => "/bin/echo \"${demo_password}\" | /opt/puppetlabs/bin/puppet-access login --username ${demo_username} --service-url https://master.inf.puppetlabs.demo:4433/rbac-api --lifetime 1y --token-file ${demo_token_file}",
    creates => $demo_token_file,
  }

  exec { "create ${deploy_username} rbac token" :
    command => "/bin/echo \"${deploy_password}\" | /opt/puppetlabs/bin/puppet-access login --username ${deploy_username} --service-url https://master.inf.puppetlabs.demo:4433/rbac-api --lifetime 1y --token-file ${deploy_token_file}",
    creates => $deploy_token_file,
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
