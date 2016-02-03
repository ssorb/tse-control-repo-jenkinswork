class profile::vsphere::vsphere_vms (
  $status     = absent,
  $vspheredatacenter = 'west1',
  $template = "/${vspheredatacenter}/vm/Templates/centos7",
  # This is required, please check before clobbering someone else's vms
  $folder,
){

  require profile::vsphere::vsphere_server

  # Relationship example:
  vsphere_vm { "/${vspheredatacenter}/vm/TSEs/${folder}/mydatabase":
    ensure              => $status,
    source              => $template,
    memory              => 2048,
    cpus                => 2,
  }
  vsphere_vm { "/${vspheredatacenter}/vm/TSEs/${folder}/mywebserver1":
    ensure  => $status,
    source  => $template,
    memory  => 1024,
    cpus    => 1,
    require => Vsphere_vm["/${vspheredatacenter}/vm/TSEs/${folder}/mydatabase"]
  }
  vsphere_vm { "/${vspheredatacenter}/vm/TSEs/${folder}/mywebserver2":
    ensure  => $status,
    source  => $template,
    memory  => 1024,
    cpus    => 1,
    require => Vsphere_vm["/${vspheredatacenter}/vm/TSEs/${folder}/mydatabase"]
  }
  vsphere_vm { "/${vspheredatacenter}/vm/TSEs/${folder}/myloadbalancer":
    ensure  => $status,
    source  => $template,
    memory  => 512,
    cpus    => 1,
    require => Vsphere_vm["/${vspheredatacenter}/vm/TSEs/${folder}/mywebserver1","/${vspheredatacenter}/vm/TSEs/${folder}/mywebserver2"]
  }

# # Purging example:
#  resources { 'vsphere_vm':
#    purge => true,
#    noop  => true,
#  }

# # Hiera example 1:
#  vsphere_vm { hiera_array('hiera_vms1'):
#    ensure  => absent,
#    source  => $template,
#    memory  => 512,
#    cpus    => 1,
#  }
#
# # Hiera example 2:
#  $vm_hash = hiera('hiera_vms2', {})
#  create_resources('vsphere_vm', $vm_hash)
}
