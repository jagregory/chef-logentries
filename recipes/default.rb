include_recipe 'apt'
#include_recipe 'yum'

case node['platform']
  when "ubuntu"
    apt_repository 'logentries' do
      uri 'http://rep.logentries.com/'
      components ['precise', 'main']
      keyserver 'pgp.mit.edu'
      key 'C43C79AD'
    end
  when "amazon"
    cookbook_file "logentries.repo" do
      source "logentries.repo"
      path "/etc/yum.repos.d/logentries.repo"
      owner "root"
      group "root"
      mode 0644
      action :create_if_missing
    end
end


package 'logentries' 
package 'logentries-daemon' do
  action :nothing
end

service 'logentries' do
  supports [:start, :stop, :restart, :reload]
  action :nothing
end

if node['logentries']
  Chef::Application.fatal!("Missing logentries server_name.") unless node['logentries']['server_name']
  Chef::Application.fatal!("Missing logentries account_key.") unless node['logentries']['account_key']

  logentries do
    account_key node['logentries']['account_key']
    server_name node['logentries']['server_name']

    action :register
  end

  log_files = node['logentries']['log_files'] || {}
  Chef::Application.fatal!("Expected hash of name => path for logentries log_files.") unless log_files.is_a? Hash

  log_files.each do |log_name,log_path|
    logentries log_path do
      log_name log_name
      action :follow
    end
  end
end

# restart the service if it's running
service 'logentries' do
  action :restart
  only_if 'service logentries status' # status returns 0 if the service is running
end

# start the service if it isn't. We do it like this because logentries
# start borks if the service is already running.
service 'logentries' do
  action :start
  not_if 'service logentries status' # status returns 0 if the service is running
end