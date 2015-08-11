# This is a Puppetfile, which describes a collection of Puppet modules. For
# format and syntax examples, see one of the following resources:
#
# https://github.com/rodjek/librarian-puppet/blob/master/README.md
# https://github.com/adrienthebo/r10k/blob/master/README.markdown
#
# Brief example:
#
#   mod 'puppetlabs/stdlib', '4.1.0'
#
# The default production environment for the SE Team is just going to pull in
# the current version of our "profile" module from the Forge and whatever
# dependencies it has.

forge "https://forgeapi.puppetlabs.com"

# PL Modules

mod 'puppetlabs/java', '1.4.1'
mod 'puppetlabs/git', '0.4.0'
mod 'dism',
  :git => 'https://github.com/puppetlabs/puppetlabs-dism.git',
  :ref => '3fbca76c50efe62ed1db9231cecb787c6a52d096'
mod 'puppetlabs/reboot', '1.1.0'
mod 'puppetlabs/registry', '1.1.0'
mod 'puppetlabs/acl', '1.1.1'
mod 'puppetlabs/apache', '1.6.0'
mod 'puppetlabs/pe_gem', '0.1.1'
mod 'puppetlabs/vcsrepo', '1.3.1'
mod 'puppetlabs/stdlib', '4.7.0'
mod 'puppetlabs/powershell', '1.0.5'
mod 'puppetlabs/ntp', '4.1.0'
mod 'puppetlabs/concat', '1.2.4'
mod 'firewall',
  :git => 'https://github.com/puppetlabs/puppetlabs-firewall.git',
  :ref => '1.7.0'
mod 'puppetlabs/inifile', '1.4.1'
mod 'puppetlabs/mysql', '3.5.0'
mod 'puppetlabs/pe_puppetserver_gem', '0.0.1'
mod 'puppetlabs/aws', '1.1.1'
mod 'puppet/windows_firewall', '1.0.0'
mod 'puppetlabs/splunk', '3.2.0'

# Community Modules

mod 'stahnma/epel', '1.0.2'
mod 'puppet/iis', '1.4.1'
mod 'puppet/windowsfeature', '1.1.0'
mod 'seteam/tomcat', '0.1.0'
mod 'seteam/profile', '1.2.0'
mod 'seteam/role', '1.2.0'
mod 'nanliu/staging', '1.0.3'
mod 'hunner/wordpress', '1.0.0'
mod 'lwf/remote_file', '1.0.1'

# TSE modules - either maintained under seteam or by individual SE's

mod 'openssh',
  :git => 'git@github.com:reidmv/puppet-module-openssh.git',
  :ref => '0e10c540f32ca2a803ca056b8da59bd33a505cee'
mod 'nonpriv',
  :git => 'git@github.com:jpadams/nonpriv.git'
mod 'dotnet',
  :git => 'https://github.com/mrzarquon/dotnet.git'
mod 'chocolatey',
  :git => 'https://github.com/mrzarquon/chocolatey.git'
mod 'cmsapp',
  :git => 'https://github.com/mrzarquon/cmsapp.git'
mod 'pe_windows_shortcuts',
  :git => 'https://github.com/sseebald/pe_windows_shortcuts.git',
  :ref => '9c3350b6b7900a7be30221c4c75832eb730742f7'
mod 'tsefacts',
  :git => 'git@github.com:mrzarquon/puppet-tse_facts.git'
mod 'ldap',
  :git => 'git@github.com:mrzarquon/puppet-ldap.git'
mod 'tse_admins',
  :git => 'git@github.com:mrzarquon/puppet-tse_admins.git'
mod 'tse_awsnodes',
  :git => 'git@github.com:mrzarquon/puppet-tse_awsnodes.git'
mod 'tse_windows',
  :git => 'git@github.com:mrzarquon/puppet-tse_windows.git'
mod 'ec2tags',
  :git => 'git@github.com:mrzarquon/puppet-ec2tags.git'
mod 'razordemo',
  :git => 'https://github.com/puppetlabs/tse-module-razordemo',
  :ref => 'a90ecd9bf78f63586a228e60381a478cea3ab22b'
