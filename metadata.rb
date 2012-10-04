maintainer       "Noan Kantrowitz"
maintainer_email "noah@coderanger.net"
license          "Apache 2.0"
description      "Install and configure the collectd monitoring daemon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.5"

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

%w{ apache2 ark build-essential }.each do |dep|
  depends dep
end
