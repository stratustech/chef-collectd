#
# Cookbook Name:: collectd
# Recipe:: source
#
# Copyright 2012, Bryan W. Berry
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

include_recipe "build-essential"
include_recipe "ark"

node[:collectd][:base_dir] = "/opt/collectd/var/lib/collectd"
node[:collectd][:plugin_dir] = "/opt/collectd/lib/collectd"
node[:collectd][:types_db] = ["/opt/collectd/share/collectd/types.db"]

# Note, if new packages are added to enable more plugins, existing
# deployments will not rebuild collectd.  To force a rebuild:
#   > rm -f /opt/collectd-5.1/{config.status,configure,sbin/collectd}

if platform_family? "debian"
  package "perl-modules"

  # "curl_json" plugin deps
  %w(libyajl1 libyajl-dev).each do |pkg|
    package pkg
  end

  # Another collectd "curl_json" plugin dep, but one that requires an
  # `apt-get update` before installing
  include_recipe "apt"
  package "libcurl4-openssl-dev" do
    action :install
    notifies :run, "execute[apt-get-update]", :immediately
  end

elsif platform_family? "rhel" and node['platform_version'].to_i > 5
  package "perl-ExtUtils-MakeMaker"

  # "curl_json" plugin deps
  %w(libcurl yajl yajl-devel).each do |pkg|
    package pkg
  end
end

ark "collectd" do
  url node[:collectd][:source_url]
  checksum node[:collectd][:checksum]
  version "5.1"
  prefix_root '/opt'
  prefix_home '/opt'
  prefix_bin  '/usr/sbin'
  has_binaries [ 'sbin/collectd' ]
  creates '/opt/collectd-5.1/sbin/collectd'
  action [ :configure, :install_with_make ]
end


if node['platform_version'].to_i < 6 and platform_family? "rhel"
  template "/etc/init.d/collectd" do
    source "collectd.init.el.erb"
    owner "root"
    group "root"
    mode "755"
    notifies :restart, resources(:service => "collectd")
  end
else
  template "/etc/init/collectd.conf" do
    source "collectd.upstart.conf.erb"
    owner "root"
    group "root"
    mode "755"
    notifies :restart, resources(:service => "collectd")
  end
end
