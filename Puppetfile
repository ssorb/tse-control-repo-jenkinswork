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

# LOCAL MODULES
# These modules are currently committed to the modules/ directory locally, but
# should ideally be converted to regular module references to the Forge or to a
# git repo.
mod 'rgbank', :local => true
mod 'http', :local => true
mod 'database', :local => true

# PL Modules

mod 'puppet/windows_firewall', '1.0.0'
mod 'puppetlabs/acl', '1.1.1'
mod 'puppetlabs/apache', '1.6.0'
mod 'puppetlabs/aws', '1.3.0'
mod 'puppetlabs/concat', '1.2.4'
mod 'puppetlabs/dism', '1.2.0'
mod 'puppetlabs/limits', '0.1.0'


# MODULES-1341 describes a situation in which firewall purging on CentOS 7
# results in erroneous errors being thrown because rules Puppet tries to delete
# are already gone. Until this is fixed in the published module, use this
# patched version.
#mod 'puppetlabs/firewall', '1.7.0'
mod 'firewall',
  :git => 'git://github.com/puppetlabs/puppetlabs-firewall.git',
  :ref => 'd33d0eb66d0b36ad9feecd2ade42f76a581612a1'

mod 'puppetlabs/git', '0.4.0'
mod 'puppetlabs/haproxy', '1.3.0'
mod 'puppetlabs/inifile', '1.4.1'
mod 'puppetlabs/java', '1.4.1'
mod 'puppetlabs/mysql', '3.5.0'
mod 'puppetlabs/ntp', '4.1.0'
mod 'puppetlabs/powershell', '1.0.5'
mod 'puppetlabs/puppetserver_gem', '0.1.0'
mod 'puppetlabs/reboot', '1.1.0'
mod 'puppetlabs/registry', '1.1.2'
mod 'puppetlabs/splunk', '3.2.0'
mod 'locp/cassandra', '1.9.2'

# We need https://github.com/puppetlabs/puppetlabs-stdlib/pull/539. That means
# we need stdlib 4.9.1 or newer. Since that hasn't been released yet,
# temporarily pulling directly from git.
#mod 'puppetlabs/stdlib', '4.9.0'
mod 'stdlib',
  :git => 'git://github.com/puppetlabs/puppetlabs-stdlib.git',
  :ref => '61333cfc48026af204483d681bd8b10cb44d6fc6'

mod 'puppetlabs/vcsrepo', '1.3.1'
mod 'puppetlabs/tomcat', '1.3.2'

# Forge Community Modules

mod 'ajjahn/samba', '0.3.1'
mod 'badgerious/windows_env', '2.2.2'
mod 'chocolatey/chocolatey', '1.2.0'
mod 'cyberious/pget', '1.1.0'
mod 'cyberious/windows_java', '1.0.2'
mod 'hunner/hiera', '2.0.1'
mod 'hunner/wordpress', '1.0.0'
mod 'lwf/remote_file', '1.1.0'
mod 'nanliu/staging', '1.0.3'
mod 'pltraining/rbac', '0.0.4'
mod 'puppet/iis', '1.4.1'
mod 'puppet/windowsfeature', '1.1.0'
mod 'stahnma/epel', '1.0.2'
mod 'tse/local_yum_repo', '0.2.0'
mod 'WhatsARanjit/node_manager', '0.2.0'
mod 'biemond/oradb', '2.0.2'
mod 'fiddyspence/sysctl', '1.1.0'
mod 'reidmv/unzip', '0.1.2'

# Git TSE modules - either maintained under seteam or by individual SE's

mod 'cmsapp',
  :git => 'git@github.com:puppetlabs/tse-module-cmsapp.git'

# This fork of puppet/dotnet includes updates to allow .NET to be idempotently
# ensured present on Server 2012, which has many .NET versions built-in. There
# is a PR to merge these changes back to the original module. As soon as a 2.0
# relase of puppet/dotnet is created we should be able to switch to that.
mod 'dotnet',
  :git => 'https://github.com/reidmv/puppet-dotnet.git',
  :ref => 'c841b36081c22de7876d85af4debf0375731d1a5'

mod 'ec2tags',
  :git => 'git@github.com:mrzarquon/puppet-ec2tags.git'
mod 'ldap',
  :git => 'git@github.com:puppetlabs/tse-module-ldapserver.git'
mod 'nonpriv',
  :git => 'git@github.com:puppetlabs/tse-module-nonpriv.git',
  :ref => '0.1.0'
mod 'openssh',
  :git => 'git@github.com:puppetlabs/tse-module-openssh.git',
  :ref => '0.1.0'
mod 'pe_windows_shortcuts',
  :git => 'git@github.com:puppetlabs/tse-module-pe_windows_shortcuts.git'
mod 'puppet_vim_env',
  :git => 'git@github.com:puppetlabs/tse-module-puppet_vim_env.git',
  :ref => '2.1.2'
mod 'razordemo',
  :git => 'git@github.com:puppetlabs/tse-module-razordemo.git',
  :ref => '3.1.1'
mod 'tse_admins',
  :git => 'git@github.com:puppetlabs/tse-module-tse_admins.git'
mod 'awsenv',
  :git => 'git@github.com:puppetlabs/tse-module-awsenv.git'
mod 'tse_facts',
  :git => 'git@github.com:puppetlabs/tse-module-tse_facts.git',
  :ref => '0.1.0'
mod 'tse_windows',
  :git => 'git@github.com:puppetlabs/tse-module-tse_windows.git'
mod 'zabbix_app',
  :git => 'git@github.com:ipcrm/appmgmt-module-zabbix_app.git'
mod 'zabbix',
  :git => 'git@github.com:ipcrm/puppet-zabbix.git'
mod 'wordpress_app',
  :git => 'git@github.com:ipcrm/apporchestration-wordpress.git'
mod 'websphere',
  :git => 'git@github.com:ipcrm/puppetlabs-websphere.git',
  :ref => 'master'
mod 'ibm_installation_manager',
  :git => 'git@github.com:ipcrm/puppetlabs-ibm_installation_manager.git',
  :ref => 'master'
mod 'cloudshop',
  :git => 'https://github.com/velocity303/puppet-cloudshop.git',
  :ref => '1.0.0'
mod 'tse_sqlserver',
  :git => 'https://github.com/velocity303/tse-module-tse_sqlserver.git',
  :ref => '1.0.0'
mod 'sqlwebapp',
  :git => 'https://github.com/velocity303/puppet-sqlwebapp.git',
  :ref => '1.0.0'
mod 'mount_iso',
  :git => 'https://github.com/puppetlabs/puppetlabs-mount_iso.git'
mod 'ipcrm/echo', '0.1.3'
