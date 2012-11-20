maintainer        "edelight GmbH"
maintainer_email  "opensource@edelight.de"
license           "Apache 2.0"
description       "Installs the kitchen app"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.0"
recipe            "kitchen", "Deploys the kitchen web app"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{ apache2 python git }.each do |cb|
  depends cb
end
