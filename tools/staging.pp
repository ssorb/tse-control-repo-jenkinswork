class splunk_files (
  $srv_root = '/opt/tse-files',
) {

  $dir_root   = "${srv_root}/demo_offline_splunk"
  $version    = '6.0'
  $build      = '182037'
  $src_root   = "http://download.splunk.com/releases/${version}"

  Remote_file {
    require => File[$dir_root],
  }

  # There are a bunch of packages that need to be retrieved, but luckily the
  # naming is algorithmic. This hash is a list of all platforms we need
  # installers for, and what architectures.
  $platforms = {
    'windows' => {
      'x64' => "${version}-${build}-x64-release.msi",
    },
    'linux'   => {
      'rpm_x86_64' => "${version}-${build}-linux-2.6-x86_64.rpm",
      'rpm_x86'    => "${version}-${build}.i386.rpm",
      'deb_x86_64' => "${version}-${build}-linux-2.6-amd64.deb",
      'deb_x86'    => "${version}-${build}-linux-2.6-intel.deb",
    },
    'solaris' => {
      'solaris_64' => "${version}-${build}-solaris-10-intel.pkg.Z",
    },
  }

  # Splunk places each kind of installer in a dir (hash key below) and prefixes
  # the filename with a potentially different string (hash value below).
  $kinds = {
    'splunk'             => 'splunk',
    'universalforwarder' => 'splunkforwarder',
  }

  file { $dir_root:
    ensure => directory,
    mode   => '0755',
  }

  $kinds.each |$dir,$prefix| {
    file { "${dir_root}/${dir}":
      ensure => directory,
      mode   => '0755',
    }
  }

  $platforms.each |$platform,$architecture| {
    # Make sure directories exist for the platform's splunk installers and
    # universalforwarders
    $kinds.each |$dir,$prefix| {
      file { "${dir_root}/${dir}/${platform}":
        ensure => directory,
        mode   => '0755',
      }
    }

    $architecture.each |$arch,$file| {
      # Ensure splunk and universalforwarder packages are present for each listed
      # architecture and file
      $kinds.each |$dir,$prefix| {
        remote_file { "${prefix}-${file}":
          source => "${src_root}/${dir}/${platform}/${prefix}-${file}",
          path   => "${dir_root}/${dir}/${platform}/${prefix}-${file}",
        }
      }
    }
  }

  # Solaris is special and needs the package to be decompressed
  $platforms['solaris'].each |$arch,$file| {
    $kinds.each |$dir,$prefix| {
      exec { "extract ${prefix}-${file}":
        path     => '/usr/bin:/bin',
        cwd      => "${dir_root}/${dir}/solaris",
        provider => shell,
        command  => "gzip -dc ${prefix}-${file} > ${prefix}-${file[0,-3]}",
        creates  => "${dir_root}/${dir}/solaris/${prefix}-${file[0,-3]}",
        require  => Remote_file["${prefix}-${file}"],
      }
    }
  }

}


class dotnetcms_files (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/dotnetcms",
    "${srv_root}/7zip",
  ]

  Remote_file {
    require => File[$directories],
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  # dotnetcms
  remote_file { 'dotNetFx40_Full_x86_x64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/dotNetFx40_Full_x86_x64.exe',
    path   => "${srv_root}/dotnetcms/dotNetFx40_Full_x86_x64.exe",
  }
  remote_file { 'CMS4.06.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/CMS4.06.zip',
    path   => "${srv_root}/dotnetcms/CMS4.06.zip",
  }

  # 7zip
  remote_file { '7z920-x64.msi':
    source => 'https://s3.amazonaws.com/saleseng/files/7zip/7z920-x64.msi',
    path   => "${srv_root}/7zip/7z920-x64.msi",
  }

}

class tomcat_files (
  $srv_root = '/opt/tse-files',
) {

  $directories = [
    "${srv_root}/tomcat",
    "${srv_root}/war",
    "${srv_root}/war/1.400",
    "${srv_root}/war/1.449",
    "${srv_root}/war/1.525",
    "${srv_root}/war/latest",
  ]

  Remote_file {
    require => File[$directories],
  }

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  remote_file { 'apache-tomcat-6.0.44.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-6.0.44.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-6.0.44.tar.gz",
  }
  remote_file { 'apache-tomcat-7.0.64.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-7.0.64.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-7.0.64.tar.gz",
  }
  remote_file { 'apache-tomcat-8.0.26.tar.gz':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.26.tar.gz',
    path   => "${srv_root}/tomcat/apache-tomcat-8.0.26.tar.gz",
  }
  remote_file { 'apache-tomcat-6.0.44.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-6.0.44.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-6.0.44.exe",
  }
  remote_file { 'apache-tomcat-7.0.64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-7.0.64.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-7.0.64.exe",
  }
  remote_file { 'apache-tomcat-8.0.26.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/apache-tomcat-8.0.26.exe',
    path   => "${srv_root}/tomcat/apache-tomcat-8.0.26.exe",
  }
  remote_file { 'jenkins-1.400.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.400.war',
    path   => "${srv_root}/war/1.400/jenkins.war",
  }
  remote_file { 'jenkins-1.449.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/jenkins-1.449.war',
    path   => "${srv_root}/war/1.449/jenkins.war",
  }
  remote_file { 'jenkins-1.525.war':
    source => 'http://mirrors.jenkins-ci.org/war/1.525/jenkins.war',
    path   => "${srv_root}/war/1.525/jenkins.war",
  }
  remote_file { 'jenkins-latest.war':
    source => 'http://mirrors.jenkins-ci.org/war/latest/jenkins.war',
    path   => "${srv_root}/war/latest/jenkins.war",
  }
  remote_file { 'sample-1.0.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.0.war',
    path   => "${srv_root}/tomcat/plsample-1.0.war",
  }
  remote_file { 'sample-1.2.war':
    source => 'https://s3.amazonaws.com/saleseng/files/tomcat/sample-1.2.war',
    path   => "${srv_root}/tomcat/plsample-1.2.war",
  }
}

$tse_files = '/opt/tse-files'

file { $tse_files:
  ensure => directory,
}

class { 'splunk_files':    srv_root => $tse_files }
class { 'dotnetcms_files': srv_root => $tse_files }
class { 'tomcat_files':    srv_root => $tse_files }
