def package_url(version)
  "http://aphyr.com/riemann/riemann_#{version}_all.deb"
end

include Chef::Mixin::ShellOut

def installed?
  shell_out('dpkg -s riemann').stderr.empty?
end

action :install do

  version = node['riemann']['version']
  riemann_user = node['riemann']['user']
  user riemann_user do
    home node['riemann']['home']
    shell '/bin/bash'
    system true
  end

  if installed?
    Chef::Log.info "riemann package has been found"
  else
    cached_file = "#{Chef::Config[:file_cache_path]}/riemann_#{version}_all.deb"

    remote_file cached_file do
      source package_url(version)
      mode 0644    
    end

    dpkg_package cached_file
  end
  
  riemann_service = runit_service 'riemann' do
    supports :restart => true
    default_logger true
    cookbook 'riemann'
  end

  directory "/etc/riemann/config.d" do
    owner riemann_user
  end

  template "/etc/riemann/riemann.conf" do
    source "riemann.conf.erb"
    owner riemann_user
    mode 0644
    variables({
      host: new_resource.host
    })
  end

end

