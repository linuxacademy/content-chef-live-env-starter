current_dir = File.dirname(__FILE__)
node_name "pivotal"
chef_server_url "https://chef.example.com:443"
chef_server_root "https://chef.example.com:443"
client_key "#{current_dir}/pivotal.pem"
ssl_verify_mode :verify_none
