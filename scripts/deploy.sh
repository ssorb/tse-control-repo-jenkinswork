#!/bin/bash

# this is the universal configuration script
# untar the environments code, and this now
# moves everything it needs into place
# and configures the master
PATH="/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin:/opt/puppet/bin:$PATH"
puppet_environmentpath=$(puppet config print environmentpath)

working_dir=$(basename $(cd $(dirname $0) && pwd))
containing_dir=$(cd $(dirname $0)/.. && pwd)
puppet_environmentpath=$(puppet config print environmentpath)
tools_path="${puppet_environmentpath}/production/scripts"
basename="${containing_dir}/${working_dir}"

# see if we are already in our working directory
if [ $basename != "${puppet_environmentpath}/production/scripts" ]; then
  /bin/cp -Rfu $basename/../* $puppet_environmentpath/production/
fi

# apply our master role
puppet apply --exec 'include role::puppet::master'

# make sure services are restarted, since role::master doesn't cleanly notify
# pe-puppetserver when configuration is changed
puppet resource service pe-puppetserver ensure=stopped
puppet resource service pe-puppetserver ensure=running
puppet resource service pe-nginx ensure=stopped
puppet resource service pe-nginx ensure=running

puppet apply $tools_path/staging.pp

puppet apply $tools_path/offline_repo.pp

/bin/bash $tools_path/refresh_classes.sh

puppet apply $tools_path/classifier.pp

/bin/bash $tools_path/connect_ds.sh

puppet agent --onetime --no-daemonize --color=false --verbose

if [ ! -z "$(facter -p ec2_iam_info_0)" ]; then
  echo "on a properly setup AWS node, deploy the herd"
  gem install aws-sdk-core retries
  puppet apply --exec 'include tse_awsnodes::deploy'
fi
