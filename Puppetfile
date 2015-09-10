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
# In addition to the component modules listed here, the default production
# environment for the TSE Team also includes a role and profile module in the
# site directory.

forge "https://forgeapi.puppetlabs.com"

# PL Modules

mod 'puppetlabs/java', '1.4.1'
mod 'puppetlabs/git', '0.4.0'
mod 'puppetlabs/dism', '1.2.0'
mod 'puppetlabs/reboot', '1.1.0'
mod 'puppetlabs/registry', '1.1.0'
mod 'puppetlabs/acl', '1.1.1'
mod 'puppetlabs/apache', '1.6.0'
mod 'puppetlabs/vcsrepo', '1.3.1'
mod 'puppetlabs/stdlib', '4.8.0'
mod 'puppetlabs/powershell', '1.0.5'
mod 'puppetlabs/ntp', '4.1.0'
mod 'puppetlabs/concat', '1.2.4'
mod 'puppetlabs/firewall', '1.7.0'
mod 'puppetlabs/inifile', '1.4.1'
mod 'puppetlabs/mysql', '3.5.0'
mod 'puppetlabs/puppetserver_gem', '0.1.0'
mod 'puppetlabs/aws', '1.1.1'
mod 'puppet/windows_firewall', '1.0.0'
mod 'puppetlabs/splunk', '3.2.0'

# Community Modules

mod 'stahnma/epel', '1.0.2'
mod 'puppet/iis', '1.4.1'
mod 'puppet/windowsfeature', '1.1.0'
mod 'seteam/tomcat', '0.1.0'
mod 'nanliu/staging', '1.0.3'
mod 'hunner/wordpress', '1.0.0'
mod 'lwf/remote_file', '1.0.1'
mod 'chocolatey/chocolatey', '1.1.0'

# TSE modules - either maintained under seteam or by individual SE's

mod 'puppet_vim_env',
  :git => 'git@github.com:puppetlabs/tse-module-puppet_vim_env.git',
  :ref => '2.1.0'
mod 'openssh',
  :git => 'git@github.com:reidmv/puppet-module-openssh.git',
  :ref => '0e10c540f32ca2a803ca056b8da59bd33a505cee'
mod 'nonpriv',
  :git => 'git@github.com:jpadams/nonpriv.git'
mod 'dotnet',
  :git => 'https://github.com/mrzarquon/dotnet.git'
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
  :git => 'git@github.com:puppetlabs/tse-module-razordemo.git',
  :ref => 'v2.1'
