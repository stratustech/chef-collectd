# Check if collectd was compiled w/ support for postgres
# if, not fail loudly
ruby_block "check pg support" do
  block do
    unless ::File.exists? "/opt/collectd/lib/collectd/postgresql.so"
      Chef::Application.fatal!("collectd does not have postgresql support compiled in. Check that pg_config and other postgres binaries are in the PATH. If not, you need to reconfigure and recompile collectd.")
    end
  end
end

template "/etc/collectd/plugins/postgresql.conf" do
  source "postgresql.conf.erb"
  mode "0644"
  notifies :restart, "service[collectd]"
end

file "/etc/collectd/plugins/postgresql-types.db" do
  content <<EOF
pg_lock_count    value:GAUGE:0:U
pg_datname_connections    value:GAUGE:0:U
pg_username_connections   value:GAUGE:0:U
EOF
  mode "0644"
end
