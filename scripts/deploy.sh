#!/bin/bash

# this is the universal configuration script
# untar the environments code, and this now
# moves everything it needs into place
# and configures the master
PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"

working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
puppet_environmentpath=$(puppet config print environmentpath)
tools_path="${puppet_environmentpath}/production/scripts"
basename="${containing_dir}/${working_dir}"

# see if we are already in our working directory
if [ $basename != "${puppet_environmentpath}/production/scripts" ]; then
  /bin/cp -Rfu $basename/../* $puppet_environmentpath/production/
fi

# Bootstrap classification by using puppet-apply to configure the node manager.
# Specify the classifier node_terminus to puppet-apply in order to include not
# just role::master, but also default Puppet Enterprise classification in the
# run.
/bin/bash $tools_path/refresh_classes.sh
puppet apply \
  --node_terminus classifier \
  --exec 'include role::master'

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
