# this recipe configures the graphite plugin

template "/etc/collectd/plugins/write_graphite.conf" do
  source "graphite.conf.erb"
  owner "root"
  group "root"
  mode "755"
end
