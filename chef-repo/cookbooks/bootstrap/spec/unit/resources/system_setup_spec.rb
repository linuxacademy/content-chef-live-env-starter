require 'spec_helper'

describe 'system_setup_test::default' do
  context 'When all attributes are default, on CentOS 7.4.1708' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'centos',
        version: '7.4.1708',
        step_into: [:system_setup],
      ) do |node, server|
        server.create_data_bag('sysadmins', {
          'oscar' => {
            'id' => 'oscar',
            'packages' => [
              'vim',
              'python',
            ]
          }
        })

        server.create_data_bag('system_setups', {
          'david' => {
            'id' => 'david',
            'packages' => [
              'wget',
            ]
          },
          'kayla' => {
            'id' => 'kayla',
            'packages' => [
              'nano'
            ]
          }
        })
      end

      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates the david user' do
      expect(chef_run).to create_user('david')
    end

    it 'does not create user oscar' do
      expect(chef_run).to_not create_user('oscar')
    end

    it 'removes user kayla' do
      expect(chef_run).to remove_user('kayla')
    end

    it 'does not attempt to remove billy' do
      expect(chef_run).to_not remove_user('billy')
    end

    it 'installs packages from david and oscars data bags' do
      expect(chef_run).to install_package('vim')
      expect(chef_run).to install_package('python')
      expect(chef_run).to install_package('wget')
    end

    it 'does not install packages from the kayla data bag' do
      expect(chef_run).to_not install_package('nano')
    end
  end
end
