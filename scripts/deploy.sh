#!/bin/bash

# This is the universal configuration script. Untar the environments code, and
# this moves everything it needs into place and configures the master.

PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"
puppet_environmentpath=$(puppet config print environmentpath)
tools_path="${puppet_environmentpath}/production/scripts"

main()
{
  sync_environment_contents

  # Bootstrap classification by using puppet-apply to configure the node
  # manager, then running puppet-agent to enforce all configured state.
  /bin/bash $tools_path/refresh_classes.sh
  puppet apply --exec 'include profile::master::node_manager'
  puppet agent --onetime --no-daemonize --color=false --verbose

  # We don't yet have the RBAC Directory Service puppetized so we have to
  # configure it separately. Sadness.
  /bin/bash $tools_path/connect_ds.sh

  # We aren't sure it's a good idea to enforce puppetlabs/aws resources during
  # regular runs. For now, just do it as a one-time deploy action.
  if [ ! -z "$(facter -p ec2_iam_info_0)" ]; then
    echo "on a properly setup AWS node, deploy the herd"
    gem install aws-sdk-core retries
    puppet apply --exec 'include tse_awsnodes::deploy'
  fi
}

sync_environment_contents()
{
  working_dir=$(basename $(cd $(dirname $0) && pwd))
  containing_dir=$(cd $(dirname $0)/.. && pwd)
  basename="${containing_dir}/${working_dir}"

  # see if we are already in our working directory
  if [ $basename != "${puppet_environmentpath}/production/scripts" ]; then
    echo "Syncing environment contents from $containing_dir to $puppet_environmentpath/production/"
    /bin/cp -Rfu "$containing_dir/"* "$puppet_environmentpath/production/"
  fi
}

main "$@"
