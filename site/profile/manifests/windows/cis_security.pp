class profile::windows::cis_security {

  # CIS Microsoft Windows Server 2012 R2 v2.2.0 04-28-2016
  # https://benchmarks.cisecurity.org/tools2/windows/CIS_Microsoft_Windows_Server_2012_R2_Benchmark_v2.2.0.pdf


  # 2.3.1.3 (L1) Ensure 'Accounts: Guest account status' is set to 'Disabled' (Scored)
  # 2.3.1.6 (L1) Configure 'Accounts: Rename guest account' (Scored)
  user { 'guest':
    ensure => 'absent',
  }

  # 9.1.1 (L1) Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)' (Scored)
  service {'MpsSvc':
    ensure   => 'running',
    enable   => 'true',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }
                  
  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile\EnableFirewall':
    type   => dword,
    data   => '1',
    notify => Service['MpsSvc'],
  }

  # 19.6.5.1.1 (L2) Ensure 'Turn off Help Experience Improvement Program' is set to 'Enabled' (Scored)
  registry_value { 'HKEY_LOCAL_MACHINE\Software\Microsoft\SQMClient\Windows\CEIPEnable':
    type   => dword,
    data   => '0',
  }

}
