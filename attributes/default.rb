#
# Cookbook Name:: kitchen
# Attributes:: default
#
# Copyright 2012, edelight GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default[:kitchen][:alias] = false
default[:kitchen][:deploy_path] = "/opt/kitchen"
default[:kitchen][:repo_path] = "/var/lib/kitchen"
default[:kitchen][:log_path] = "/var/log/kitchen"
default[:kitchen][:debug] = false

default[:kitchen][:revision] = "HEAD"
default[:kitchen][:source] = "git://github.com/idevops/vitrine.git"

default[:kitchen][:repo][:sync_period] = 2
default[:kitchen][:repo][:name] = "myreponame"
default[:kitchen][:repo][:url] = ""
default[:kitchen][:repo][:kitchen_dir] = ""
default[:kitchen][:repo][:env_prefix] = "env"
default[:kitchen][:repo][:default_env] = "production"
default[:kitchen][:repo][:default_virt] = "guest"

default[:kitchen][:plugins][:enable] = []
default[:kitchen][:plugins][:install] = []

default[:kitchen][:show_virt_view] = true
default[:kitchen][:tag_classes] = {
    "WIP" => "btn-warning",
    "dummy" => "btn-danger",
}
