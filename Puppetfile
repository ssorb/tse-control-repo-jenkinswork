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
mod 'puppetlabs/java'
mod 'puppetlabs/git'
mod 'puppetlabs/dism'
mod 'puppetlabs/reboot'
mod 'puppetlabs/registry'
mod 'puppetlabs/acl'
mod 'puppetlabs/apache'
mod 'puppetlabs/pe_gem'
mod 'puppetlabs/vcsrepo'
mod 'puppetlabs/stdlib'
mod 'puppetlabs/powershell'
mod 'puppetlabs/ntp'
#mod 'puppetlabs/tomcat', '1.1.0'
mod 'puppetlabs/concat'
mod 'puppetlabs/firewall'
mod 'puppetlabs/inifile'
mod 'puppetlabs/mysql'
mod 'puppetlabs/pe_puppetserver_gem'

# Community Modules

mod 'stahnma/epel'
mod 'opentable/iis'
mod 'opentable/windowsfeature'
mod 'seteam/tomcat'
mod 'seteam/profile'
mod 'seteam/role'
mod 'nanliu/staging'
mod 'elasticsearch/elasticsearch'
mod 'gini/archive'
mod 'cprice404/grafanadash'
mod 'dwerder/graphite'
mod 'hunner/wordpress'


# TSE modules - either maintained under seteam
# or by individual SE's
# mod 'seteam/profile', '0.2.4'
mod 'seteam/splunk'
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
  :git => 'git@github.com:mrzarquon/tsefacts.git'
mod 'ldap',
  :git => 'git@github.com:mrzarquon/puppet-ldap.git'
mod 'windows',
  :git => 'git@github.com:mrzarquon/puppet-windows.git'
mod 'tse_admins',
  :git => 'git@github.com:mrzarquon/puppet-tse_admins.git'

# Dave's modules
mod 'tse_sqlserver',
  :git => 'git@github.com:dgrstl/tse_sqlserver.git'
