name 'chef-server'
maintainer 'Max Korenkov'
maintainer_email 'mkorenkov@gmail.com'
license 'Apache 2.0'
description 'Installs and configures Chef Server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.3'

%w{ ubuntu }.each do |os|
  supports os
end