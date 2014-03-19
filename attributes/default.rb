default['chef-server']['package_url'] = 'https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chef-server_11.0.10-1.ubuntu.12.04_amd64.deb'
default['chef-server']['api_fqdn'] = node['fqdn']
default['chef-server']['token_timeout'] = 7200