# Setup PostgreSQL Install
postgresql_version = '9.6'

case node['platform_family']
when 'rhel', 'fedora'
  remote_file "/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-#{postgresql_version}" do
    source "https://download.postgresql.org/pub/repos/yum/RPM-GPG-KEY-PGDG"
  end

  yum_repository "PostgreSQL #{postgresql_version}" do # ~FC005
    repositoryid "pgdg#{postgresql_version}"
    description "PostgreSQL.org #{postgresql_version}"
    if node['platform_family'] == 'fedora'
      baseurl 'https://download.postgresql.org/pub/repos/yum/9.6/fedora/fedora-$releasever-$basearch'
    else
      baseurl 'https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-$releasever-$basearch'
    end
    enabled     true
    gpgcheck    true
    gpgkey      "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-#{postgresql_version}"
  end
when 'debian'
  apt_update

  package 'language-pack-en'
  package 'apt-transport-https'

  apt_repository 'postgresql_org_repository' do
    uri          'https://download.postgresql.org/pub/repos/apt/'
    components   ['main', postgresql_version]
    distribution "#{node['lsb']['codename']}-pgdg"
    key "https://download.postgresql.org/pub/repos/apt/ACCC4CF8.asc"
    cache_rebuild true
  end
else
  raise "The platform_family '#{node['platform_family']}' or platform '#{node['platform']}' is not supported by this cookbook."
end

# Install PostgreSQL Server Package
case node['platform_family']
when 'rhel', 'fedora'
  package "postgresql#{postgresql_version.delete('.')}-server"
when 'debian'
  package "postgresql-#{postgresql_version}"
end

# Setup pg_hba.conf
if node['platform_family'] == 'debian'
  cookbook_file "/etc/postgresql/#{postgresql_version}/main/pg_hba.conf" do
    source "pg_hba.conf"
  end
end

# Initialize Database
execute 'init_db' do
  command "/usr/pgsql-#{postgresql_version}/bin/initdb -D /var/lib/pgsql/#{postgresql_version}/data"
  user 'postgres'
  not_if { ::File.exists?("/var/lib/pgsql/#{postgresql_version}/data/PG_VERSION") }
  only_if { ['rhel', 'fedora'].include?(node['platform_family']) }
end

# Start Database Service
service 'postgresql' do
  case node['platform_family']
  when 'rhel', 'fedora'
    service_name "postgresql-#{postgresql_version}"
  when 'debian'
    service_name 'postgresql'
  end
  action [:start, :enable]
end

# Set postgres User Password
if node['postgres_password']
  bash 'set-postgres-password' do
    user 'postgres'
    code "/usr/bin/psql -c \"ALTER ROLE postgres ENCRYPTED PASSWORD '#{node['postgres_password']}';\" -U postgres"
    not_if do
      # Don't set password if it is already set
      sql = %(SELECT rolpassword from pg_authid WHERE rolname='postgres' AND rolpassword IS NOT NULL;)
      query = shell_out("/usr/bin/psql -c \"#{sql}\" -U postgres", user: 'postgres')
      query.stdout =~ /1 row/ ? true : false
    end
  end
end

# Create Databases based on content from DB API
uri = URI("http://data.example.com/databases/#{node['db_role']}")
get_request = Net::HTTP::Get.new(uri, 'Content-Type' => 'application/json')
http_client = Net::HTTP.new(uri.host, uri.port)
response = http_client.request(get_request)

if response.code == '200'
  databases = JSON.parse(response.body)

  databases.each do |db|
    db_sql = db['tables'].join()

    db_exists = lambda do
      sql = %(SELECT datname from pg_database WHERE datname='#{db['name']}')
      query = shell_out("/usr/bin/psql -c \"#{sql}\" -U postgres", user: 'postgres')
      query.stdout =~ /1 row/ ? true : false
    end.call()

    bash "create-db-#{db['name']}" do
      user 'postgres'
      code "createdb -E UTF-8 -U postgres #{db["name"]}"
      not_if { db_exists }
    end

    bash "create-tables-for-#{db['name']}" do
      user 'postgres'
      code "/usr/bin/psql -c \"#{db_sql}\" -U postgres -d #{db['name']}"
      not_if { db_exists }
    end
  end
end
