# Setup Chef Rest Client
Chef::Config.from_file(Rails.root.join("config", "chef", "pivotal.rb").to_s)
