system_setup 'david'

system_setup 'oscar' do
  manage_user false
  data_bag 'sysadmins'
end

system_setup 'kayla' do
  action :delete
end

system_setup 'billy' do
  manage_user false
  action :delete
end
