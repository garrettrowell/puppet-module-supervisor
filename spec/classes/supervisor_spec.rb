require 'spec_helper'

describe 'supervisor', :type => :class do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'default params' do
        it do
          is_expected.to contain_class('supervisor::update')
        end

        it do
          is_expected.to contain_package('supervisor').with(
            'ensure' => 'present'
          )
        end

        it do
          is_expected.to contain_file('/etc/supervisord.d').with(
            'ensure'  => 'directory',
            'purge'   => true,
            'recurse' => false,
            'require' => 'Package[supervisor]'
          )
        end

        it do
          is_expected.to contain_file('/var/log/supervisor').with(
            'ensure'  => 'directory',
            'purge'   => true,
            'backup'  => false,
            'require' => 'Package[supervisor]'
          )
        end

        it do
          is_expected.to contain_file('/var/run/supervisor').with(
            'ensure'  => 'directory',
            'purge'   => true,
            'backup'  => false,
            'require' => 'Package[supervisor]'
          )
        end

        it do
          is_expected.to contain_file('/etc/supervisord.conf').with(
            'ensure'  => 'file',
            'require' => 'File[/etc/supervisord.d]',
            'notify'  => 'Service[supervisord]'
          )
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/supervisor').with(
            'ensure'  => 'file',
            'require' => 'Package[supervisor]'
          )
        end

        it do
          is_expected.to contain_service('supervisord').with(
            'ensure'     => 'running',
            'enable'     => true,
            'hasrestart' => true,
            'require'    => 'File[/etc/supervisord.conf]'
          )
        end
      end
    end
  end
end
