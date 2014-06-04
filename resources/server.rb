actions :install
default_action :install

attribute :host, name_attribute: true
attribute :cookbook, kind_of: String, default: 'riemann'
