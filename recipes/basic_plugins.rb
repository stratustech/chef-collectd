# This recipe installs the most frequently used plugins without
# any special configuration

%w{syslog cpu interface load memory network df disk}.each do |plugin|
  collectd_plugin plugin
end
