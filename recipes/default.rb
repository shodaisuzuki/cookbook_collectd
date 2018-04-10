install_dir = "/etc/collectd"
directory install_dir do
  owner user
  group user
  mode 0755
  action :create
  not_if { Dir.exist? install_dir }
end

conf_dir = "/opt/collectd-plugins/cloudwatch/config/" 
directory conf_dir do
  owner user
  group user
  mode 0755
  recursive true
  action :create
  not_if { Dir.exist? conf_dir }
end

%w{collectd collectd-python}.each do |pkg|
  package pkg do
    action :install
  end
end

service "collectd" do
  action :enable
end

git "/etc/collectd" do
  repository "https://github.com/awslabs/collectd-cloudwatch.git"
  action :sync
end

template "/opt/collectd-plugins/cloudwatch/config/whitelist.conf" do
  mode 755
  source 'whitelist.conf'
end

execute 'setup collectd' do
  command <<-CODE
    (echo "1"; echo "1"; echo "1"; echo "1"; echo "1"; echo "1"; echo "1"; echo "2"; echo "1"; echo "3"; cat) | /etc/collectd/src/setup.py
  CODE
end
