# See https://docs.chef.io/config_rb.html for more information on chef configuration options

chef_username = 'cloud_user'

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                chef_username
client_key               "#{current_dir}/#{chef_username}.pem"
chef_server_url          "https://chef.example.com/organizations/examplecom"
cookbook_path            ["#{current_dir}/../cookbooks"]
