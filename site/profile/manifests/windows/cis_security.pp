class profile::windows::cis_security {

  # CIS Microsoft Windows Server 2012 R2 v2.2.0 11-04-2014
  # https://benchmarks.cisecurity.org/tools2/windows/CIS_Microsoft_Windows_Server_2012_R2_Benchmark_v2.2.0.pdf


  # 1.1.2 (L1) Ensure 'Maximum password age' is set to '60 or fewer days, but not 0' (Scored)
  exec {'Set Max Password Age':
    command  => "net accounts /maxpwage:15",
    provider => 'powershell',
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
    data   => 'O',
  }

}
