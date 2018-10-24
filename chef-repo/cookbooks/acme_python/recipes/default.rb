remote_file '/tmp/get-pip.py' do
  source 'https://bootstrap.pypa.io/get-pip.py'
end

execute 'install pip' do
  command 'python /tmp/get-pip.py'
  not_if 'which pip'
end
