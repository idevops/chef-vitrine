#
# Cookbook Name:: kitchen
# Recipe:: default
#
# Copyright 2012, edelight GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "python"
include_recipe "git"
include_recipe "apache2::mod_wsgi"

package "graphviz"

python_pip pyparsing do
  version "1.5.7"
  action :install
end

%w{django logbook littlechef pydot}.each do |pkg|
  python_pip pkg do
    action :install
  end
end

# Create needed deployment directories
%w{wsgi shared}.each do |dir|
  directory "#{node['kitchen']['deploy_path']}/#{dir}" do
    mode "0775"
    owner "www-data"
    group "www-data"
    recursive true
    action :create
  end
end

directory "#{node['kitchen']['repo_path']}" do
  mode "0775"
  owner "www-data"
  group "www-data"
  action :create
end

directory "#{node['kitchen']['log_path']}" do
  mode "0775"
  owner "www-data"
  group "www-data"
  recursive true
  action :create
end

template "#{node['kitchen']['deploy_path']}/wsgi/webapp.wsgi" do
  source "wsgi.erb"
  owner "www-data"
  group "www-data"
  mode "0644"
end

# Remove Apache's default site and create kitchen' webapp site
apache_site "000-default" do
  enable false
end

web_app "kitchen" do
  template "wsgi_site.erb"
end

# Deploy kitchen revision
current_root = "#{node['kitchen']['deploy_path']}/current"

deploy_revision node['kitchen']['deploy_path'] do
  repo node[:kitchen][:source]
  revision node['kitchen']['revision']
  user "www-data"
  group "www-data"
  symlink_before_migrate ({})
  create_dirs_before_symlink []
  purge_before_symlink []
  symlinks ({})
  scm_provider Chef::Provider::Git
  action :deploy
  notifies :create, "template[#{current_root}/kitchen/settings.py]"
end

template "#{current_root}/kitchen/settings.py" do
  source "settings.py.erb"
  owner "www-data"
  group "www-data"
  mode "0644"
  notifies :restart, "service[apache2]"
end

node['kitchen']['plugins'].each do |plugin|
  cookbook_file "#{plugin}.py" do
    path "#{node['kitchen']['deploy_path']}/current/kitchen/backends/plugins/#{plugin}.py"
    owner "www-data"
    group "www-data"
    mode "0644"
    notifies :restart, "service[apache2]"
  end
end

cron "kitchen_update" do
  minute "1-59/#{node['kitchen']['repo']['sync_period']}"
  user "www-data"
  command "python #{node['kitchen']['deploy_path']}/current/kitchen/backends/repo_sync.py"
end
