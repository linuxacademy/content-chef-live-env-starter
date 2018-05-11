name = File.read("/etc/chef/node_name.txt").strip if File.exists?('/etc/chef/node_name.txt')
name = "example-node1" if name.empty?

chef_server_url 'https://chef.example.com/organizations/examplecom'
validation_client_name 'examplecom-validator'
validation_key '/etc/chef/examplecom-validator.pem'
node_name name
