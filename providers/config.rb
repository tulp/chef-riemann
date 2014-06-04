def config_file file
  file + '.clj'
end

def source_file file
  file + '.clj.erb'
end

action :install do
  riemann_user = node['riemann']['user']

  template ::File.join('/etc/riemann', 'config.d', config_file(new_resource.source)) do
    source source_file(new_resource.source)
    owner riemann_user
    mode 0644
    variables(new_resource.variables)
  end
end
