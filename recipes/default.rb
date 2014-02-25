require 'resolv'
require 'chef/util/file_edit'

src_filename = ::File.basename(node['chef-server']['package_url'])
file_path = "#{Chef::Config['file_cache_path']}/#{src_filename}"

remote_file file_path do
  source node['chef-server']['package_url']
  action :create_if_missing
end

execute "dpkg -i #{file_path}" do
  user 'root'
end

ruby_block "ensure node can resolve API FQDN" do
  block do
    fe = Chef::Util::FileEdit.new("/etc/hosts")
    fe.insert_line_if_no_match(/#{node['chef-server']['api_fqdn']}/,
                               "127.0.0.1 #{node['chef-server']['api_fqdn']}")
    fe.write_file
  end
  not_if { Resolv.getaddress(node['chef-server']['api_fqdn']) rescue false } # host resolves
end

# create the chef-server etc directory
directory '/etc/chef-server' do
  owner 'root'
  group 'root'
  recursive true
  action :create
end

# create the initial chef-server config file
template '/etc/chef-server/chef-server.rb' do
  source 'chef-server.rb.erb'
  owner 'root'
  group 'root'
  action :create
  notifies :run, 'execute[reconfigure-chef-server]', :immediately
end

# reconfigure the installation
execute 'reconfigure-chef-server' do
  command 'chef-server-ctl reconfigure'
  action :nothing
end