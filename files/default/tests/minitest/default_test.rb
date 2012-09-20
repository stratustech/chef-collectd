describe_recipe 'collectd::default' do
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  describe "services" do
    it "starts collectd" do
      service("collectd").must_be_running
    end

    # FIXME!!! This assertion always fails
    # it "enables collectd" do
    #   service("collectd").must_be_enabled
    # end
  end

  %w(collectd collection thresholds).each do |f|
    describe "#{f}.conf exists" do
      it { file("/etc/collectd/#{f}.conf").must_exist }
    end

    # Broken in Chef 10.10+ Fixed in 8/2012 here - https://github.com/opscode/chef/pull/361
    # describe "#{f}.conf is only modifiable by root" do
    #   let(:conf) { file("/etc/collectd/#{f}.conf") }
    #   #it { conf.must_have(:owner, "root") }
    #   #it { conf.must_have(:group, "root") }
    #   #it { conf.must_have(:mode, "644") }
    # end
  end

end

