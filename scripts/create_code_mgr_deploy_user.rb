require 'json'
require 'net/smtp'

@console_server_name   = 'localhost'
#########################
## Helpers
#########################
$puppet = '/opt/puppetlabs/bin/puppet'
credentials = {
  :cacert => %x(#{$puppet} config print localcacert),
  :cert   => %x(#{$puppet} config print hostcert),
  :key    => %x(#{$puppet} config print hostprivkey)
}

def rbac_rest_call (method, endpoint, creds, json='', api_ver='v1', console_server=@console_server_name)
  cmd = "curl -s -k -X #{method} -H 'Content-Type: application/json' \
    -d \'#{json}\' \
    --cacert #{creds[:cacert]} \
    --cert   #{creds[:cert]} \
    --key    #{creds[:key]} \
    https://#{console_server}:4433/rbac-api/#{api_ver}/#{endpoint}".delete("\n")
  resp = %x(#{cmd})
  ## don't know if api call succeeded, only if curl worked or not
  if ! $?.success?
    raise "curl rest call failed: #{$?}"
  end
  resp
end

#########################
## Create deploy user and role for code manager
#########################
user = {
  'login' => 'code_mgr_deploy_user',
  'display_name' => 'code_mgr_deploy_user',
  'password' => 'puppetlabs',
  'email' => '',
  'role_ids' => []
}
rbac_rest_call('POST', 'users', credentials, JSON.generate(user).to_s)
id = JSON.parse(rbac_rest_call('GET', 'users', credentials)).find {|j| j['login']=='code_mgr_deploy_user'}['id']

role = {
  'display_name' => 'Deploy Environments',
  'description' => '',
  'group_ids' => [],
  'user_ids' => ["#{id}"],
  'permissions' => [{'action'=>'deploy_code', 'instance'=>'*', 'object_type'=>'environment'}, {'action'=>'override_lifetime', 'instance'=>'*', 'object_type'=>'tokens'}]
}
rbac_rest_call('POST', 'roles', credentials, JSON.generate(role).to_s)
