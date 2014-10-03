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
mod 'puppetlabs/java', '1.0.1'
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
# Community Modules

mod 'stahnma/epel', '1.0.0'
mod 'simondean/iis', '0.1.3'
mod 'seteam/profile', '0.3.0'
mod 'seteam/role', '0.6.0'

# TSE modules - either maintained under seteam
# or by individual SE's
# mod 'seteam/profile', '0.2.4'
mod 'seteam/splunk', '3.0.1'
mod 'seteam/tomcat', '0.1.0'
mod 'dotnetcms',
  :git => 'git://github.com/reidmv/puppet-module-dotnetcms.git',
  :ref => '3dae59c9eb87811dfa40ae3f9d3d28a4ea5d6f62'
mod 'staging',
  :git => 'git@github.com:reidmv/puppet-module-staging.git',
  :ref => 'seteam_puppet_environments'
mod 'openssh',
  :git => 'git@github.com:reidmv/puppet-module-openssh.git',
  :ref => '0e10c540f32ca2a803ca056b8da59bd33a505cee'
