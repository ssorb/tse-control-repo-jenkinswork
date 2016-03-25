#!/bin/bash

#Setup admin user and initialize
gitlab-rails console production <<EOF
user = User.find_by(username: 'root')
user.reset_password_token=nil
user.reset_password_sent_at=nil
user.password_automatically_set=false
user.projects_limit = 1000
user.password = 'puppetlabs'
user.password_confirmation = 'puppetlabs'
user.save!
quit
EOF

tar -xzvf /vagrant/code/pe-demo-code-repos-*.tar.gz -C /var/opt/gitlab/git-data/repositories/root/ --strip 1
chown -R git:git /var/opt/gitlab/git-data/repositories/root/
gitlab-rake gitlab:import:repos
