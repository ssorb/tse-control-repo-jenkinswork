class profile::master::files::jdk (
  $srv_root = '/opt/tse-files',
) {
  file { "${srv_root}/jdk":
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'jdk-8u45-windows-x64.exe':
    source  => 'http://download.oracle.com/otn-pub/java/jdk/8u45-b15/jdk-8u45-windows-x64.exe',
    path    => "${srv_root}/jdk/jdk-8u45-windows-x64.exe",
    require => File["${srv_root}/jdk"],
  }
}
