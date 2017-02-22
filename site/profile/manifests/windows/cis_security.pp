class profile::windows::cis_security {

  # CIS Microsoft Windows Server 2012 R2 v2.2.0 11-04-2014
  # https://benchmarks.cisecurity.org/tools2/windows/CIS_Microsoft_Windows_Server_2012_R2_Benchmark_v2.2.0.pdf

  # 9.1.1 (L1) Ensure 'Windows Firewall: Domain: Firewall state' is set to 'On (recommended)' (Scored)
  service {'MpsSvc':
    ensure   => 'running',
    enable   => 'true',
  }

  registry_value { 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\EnableFirewall':
    type => dword,
    data => '1',
  }

}
