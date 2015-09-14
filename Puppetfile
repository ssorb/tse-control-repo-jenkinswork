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

mod 'puppet/windows_firewall', '1.0.0'
mod 'puppetlabs/acl', '1.1.1'
mod 'puppetlabs/apache', '1.6.0'
mod 'puppetlabs/aws', '1.1.1'
mod 'puppetlabs/concat', '1.2.4'
mod 'puppetlabs/dism', '1.2.0'
mod 'puppetlabs/firewall', '1.7.0'
mod 'puppetlabs/git', '0.4.0'
mod 'puppetlabs/inifile', '1.4.1'
mod 'puppetlabs/java', '1.4.1'
mod 'puppetlabs/mysql', '3.5.0'
mod 'puppetlabs/ntp', '4.1.0'
mod 'puppetlabs/powershell', '1.0.5'
mod 'puppetlabs/puppetserver_gem', '0.1.0'
mod 'puppetlabs/reboot', '1.1.0'
mod 'puppetlabs/registry', '1.1.0'
mod 'puppetlabs/splunk', '3.2.0'
mod 'puppetlabs/stdlib', '4.8.0'
mod 'puppetlabs/vcsrepo', '1.3.1'

# Community Modules

mod 'badgerious/windows_env', '2.2.2'
mod 'chocolatey/chocolatey', '1.1.0'
mod 'hunner/hiera', '1.3.2'
mod 'hunner/wordpress', '1.0.0'
mod 'lwf/remote_file', '1.0.1'
mod 'nanliu/staging', '1.0.3'
mod 'puppet/iis', '1.4.1'
mod 'puppet/windowsfeature', '1.1.0'
mod 'seteam/tomcat', '0.1.0'
mod 'stahnma/epel', '1.0.2'

# TSE modules - either maintained under seteam or by individual SE's

mod 'cmsapp',
  :git => 'https://github.com/mrzarquon/cmsapp.git'
mod 'dotnet',
  :git => 'https://github.com/mrzarquon/dotnet.git'
mod 'ec2tags',
  :git => 'git@github.com:mrzarquon/puppet-ec2tags.git'
mod 'ldap',
  :git => 'git@github.com:mrzarquon/puppet-ldap.git'
mod 'nonpriv',
  :git => 'git@github.com:jpadams/nonpriv.git'
mod 'openssh',
  :git => 'git@github.com:puppetlabs/tse-module-openssh.git',
  :ref => '0.1.0'
mod 'pe_windows_shortcuts',
  :git => 'https://github.com/sseebald/pe_windows_shortcuts.git',
  :ref => '9c3350b6b7900a7be30221c4c75832eb730742f7'
mod 'puppet_vim_env',
  :git => 'git@github.com:puppetlabs/tse-module-puppet_vim_env.git',
  :ref => '2.1.1'
mod 'razordemo',
  :git => 'git@github.com:puppetlabs/tse-module-razordemo.git',
  :ref => 'v2.1'
mod 'tse_admins',
  :git => 'git@github.com:mrzarquon/puppet-tse_admins.git'
mod 'tse_awsnodes',
  :git => 'git@github.com:mrzarquon/puppet-tse_awsnodes.git'
mod 'tse_facts',
  :git => 'git@github.com:puppetlabs/tse-module-tse_facts.git',
  :ref => '0.1.0'
mod 'tse_windows',
  :git => 'git@github.com:mrzarquon/puppet-tse_windows.git'
