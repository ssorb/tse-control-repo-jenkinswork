class offline_files (
  $srv_root = '/var/seteam-files',
) {

  Staging::File {
    require => File[$srv_root],
  }

  $directories = [
    "${srv_root}/dotnetcms",
    "${srv_root}/7zip",
  ]

  file { $directories:
    ensure => directory,
    mode   => '0755',
  }

  # dotnetcms
  
  staging::file { 'dotNetFx40_Full_x86_x64.exe':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/dotNetFx40_Full_x86_x64.exe',
    target => "${srv_root}/dotnetcms/dotNetFx40_Full_x86_x64.exe",
  }
  staging::file { 'CMS4.06.zip':
    source => 'https://s3.amazonaws.com/saleseng/files/dotnetcms/CMS4.06.zip',
    target => "${srv_root}/dotnetcms/CMS4.06.zip",
  }

  # 7zip

  staging::file { '7z920-x64.msi':
    source => 'https://s3.amazonaws.com/saleseng/files/7zip/7z920-x64.msi',
    target => "${srv_root}/7zip/7z920-x64.msi",
  }

}

include offline_files
