name = ENV["NODE_NAME"] || "example-node1"

chef_server_url 'https://chef.example.com/organizations/examplecom'
validation_client_name 'examplecom-validator'
validation_key '/etc/chef/examplecom-validator.pem'
node_name name
