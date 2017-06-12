class profile::windows::local_policy {

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeText':
    type => string,
    data => 'This Legal Notice Text is Managed By Puppet',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\LegalNoticeCaption':
    type => string,
    data => 'This Legal Notice Caption is Managed By Puppet',
  }

}