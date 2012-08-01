template "/etc/collectd/plugins/postgresql.conf" do
  source "postgresql.conf.erb"
  mode "0644"
  notifies :restart, resources(:service => "collectd")
end

file "/etc/collectd/plugins/postgresql-types.db" do
  content <<EOF
pg_datname_connections    value:GAUGE:0:U
pg_username_connections   value:GAUGE:0:U
EOF
  mode "0644"
end
