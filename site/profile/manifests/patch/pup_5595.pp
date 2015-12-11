class profile::patch::pup_5595 {
  if $::puppetversion == '4.3.1' {
    case $::kernel {
        'Windows' : {
          file {'pup_5595_patch':
            path   => 'C:/Program Files/Puppet Labs/Puppet/puppet/lib/puppet/transaction/additional_resource_generator.rb',
            source => 'puppet:///modules/profile/pup_5595.patch'
          }
        }
        default : {
          file {'pup_5595_patch':
            path   => '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet/transaction/additional_resource_generator.rb',
            source => 'puppet:///modules/profile/pup_5595.patch'
          }
        }
    }
  }


}
