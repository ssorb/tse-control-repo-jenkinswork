class profile::example::rgbank(
  $db_host     = 'localhost',
  $db_name     = 'wordpress',
  $db_user     = 'wordpress',
  $db_pass     = 'wordpress',
  $docroot     = '/var/www/html',
  $install_app = true,
) {
  include apache
  include apache::mod::php
  include mysql::server
  include mysql::bindings
  include mysql::bindings::php

  file {"/var/tmp/${db_name}":
    ensure => directory,
    before => Staging::Deploy['rgbank.tgz'],
  }

  staging::deploy { 'rgbank.tgz':
    source  => 'http://master.inf.puppetlabs.demo/rgbank/rgbank.tgz',
    target  => "/var/tmp/${db_name}",
    before   => Mysql::Db[$db_name],
    creates => "/var/tmp/${db_name}/rgbank.sql",
  }

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_pass,
    host     => '%',
    sql      => "/var/tmp/${db_name}/rgbank.sql",
  } ->

  mysql_user { "${db_user}@localhost":
    ensure        => 'present',
    password_hash => mysql_password($db_pass),
  } ->

  apache::vhost { $::fqdn:
    priority   => '10',
    vhost_name => $::fqdn,
    port       => '80',
    docroot      => $docroot,
    default_vhost => false,
  } ->

  wordpress::instance::app { "rgbank":
    install_dir          => $docroot,
    install_url          => 'http://wordpress.org',
    version              => '4.3.1',
    db_host              => $db_host,
    db_name              => $db_name,
    db_user              => $db_user,
    db_password          => $db_pass,
    wp_owner             => 'root',
    wp_group             => '0',
    wp_lang              => '',
    wp_config_content    => undef,
    wp_plugin_dir        => 'DEFAULT',
    wp_additional_config => 'DEFAULT',
    wp_table_prefix      => 'wp_',
    wp_proxy_host        => '',
    wp_proxy_port        => '',
    wp_multisite         => false,
    wp_site_domain       => '',
    wp_debug             => false,
    wp_debug_log         => false,
    wp_debug_display     => false,
    notify               => Service['httpd'],
  }

  file { "${docroot}/wp-content/uploads":
    ensure  => directory,
    owner   => apache,
    group   => apache,
    recurse => true,
    require => Wordpress::Instance::App["rgbank"],
  }

  file {"${docroot}/wp-content/themes/rgbank":
    ensure => directory,
    owner   => apache,
    group   => apache,
    require  => Wordpress::Instance::App["rgbank"],
    before => Staging::Deploy['theme_rgbank.tgz'],
  }

  staging::deploy { 'theme_rgbank.tgz':
    source  => 'http://master.inf.puppetlabs.demo/rgbank/rgbank.tgz',
    target  => "${docroot}/wp-content/themes/rgbank",
    creates => "${docroot}/wp-content/themes/rgbank/index.php",
    require  => Wordpress::Instance::App["rgbank"],
    notify   => Service['httpd'],
  }

  firewall { '80 allow apache access':
      dport  => [80],
      proto  => tcp,
      action => accept,
  }
}
