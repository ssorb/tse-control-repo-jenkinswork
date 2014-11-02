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
mod 'puppetlabs/java', '1.1.2'
mod 'puppetlabs/git', '0.2.0'
mod 'puppetlabs/dism', '0.1.0'
mod 'puppetlabs/reboot', '0.1.8'
mod 'puppetlabs/registry', '1.0.3'
mod 'puppetlabs/acl', '1.0.3'
mod 'puppetlabs/apache', '1.1.1'
mod 'puppetlabs/pe_gem', '0.0.1'
mod 'puppetlabs/vcsrepo', '1.1.0'
mod 'puppetlabs/stdlib', '4.3.2'
mod 'puppetlabs/powershell', '1.0.3'
mod 'puppetlabs/ntp', '3.2.1'
#mod 'puppetlabs/tomcat', '1.1.0'
mod 'puppetlabs/concat', '1.1.2'
mod 'puppetlabs/firewall', '1.1.3'
mod 'puppetlabs/inifile', '1.1.4'

# Community Modules

mod 'stahnma/epel', '1.0.0'
mod 'simondean/iis', '0.1.3'
mod 'seteam/tomcat', '0.1.0'
#mod 'seteam/profile', '0.3.0'
#mod 'seteam/role', '0.6.0'
mod 'nanliu/staging', '1.0.2'
mod 'elasticsearch/elasticsearch', '0.3.2'
mod 'gini/archive', '0.2.1'
mod 'cprice404/grafanadash', '0.0.5'
mod 'dwerder/graphite', '5.3.3'


# TSE modules - either maintained under seteam
# or by individual SE's
# mod 'seteam/profile', '0.2.4'
mod 'seteam/splunk', '3.0.1'
#mod 'dotnetcms',
#  :git => 'git://github.com/reidmv/puppet-module-dotnetcms.git',
#  :ref => '3dae59c9eb87811dfa40ae3f9d3d28a4ea5d6f62'
mod 'openssh',
  :git => 'git@github.com:reidmv/puppet-module-openssh.git',
  :ref => '0e10c540f32ca2a803ca056b8da59bd33a505cee'
mod 'nonpriv',
  :git => 'git@github.com:jpadams/nonpriv.git'
mod 'dotnet',
  :git => 'https://github.com/sseebald/dotnet.git',
  :ref => '891996e5c80dc06ed90019b8d45e3ba013d0377c'
mod 'chocolatey',
  :git => 'https://github.com/sseebald/chocolatey.git',
  :ref => '4d81e1c75b12d4f42bda5fb74f4bf9abccfc4a0b'
mod 'cmsapp',
  :git => 'https://github.com/sseebald/cmsapp.git',
  :ref => '0bfd34ffd1720baaf6e04b3cac1e4943dc394ee4'
mod 'pe_windows_shortcuts',
  :git => 'https://github.com/sseebald/pe_windows_shortcuts.git',
  :ref => '9c3350b6b7900a7be30221c4c75832eb730742f7'
mod 'win_rdp',
  :git => 'https://github.com/sseebald/win_rdp.git',
  :ref => 'a3dfad580bf9ec1f5318790cd2398f79bf482691'
mod 'tsefacts',
  :git => 'git@github.com:mrzarquon/tsefacts.git'

# in development mode
mod 'role',
  :git => 'git@github.com:mrzarquon/puppet-module-role.git'
mod 'profile',
  :git => 'git@github.com:mrzarquon/puppet-module-profile.git'
