require 'spec_helper'

describe 'supervisor::service', :type => :define do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'test' }

      let(:params) do
        {
          :command => '/ima/fake command'
        }
      end

      it do
        is_expected.to contain_file('/var/log/supervisor/test').with(
          'ensure'  => 'directory',
          'owner'   => 'root',
          'group'   => 'root',
          'mode'    => '0750',
          'recurse' => false,
          'force'   => false
        ).that_requires('Class[supervisor]')
      end

      it do
        is_expected.to contain_file('/etc/supervisord.d/test.ini').with(
          'ensure'  => nil,
          'require' => 'File[/var/log/supervisor/test]',
          'notify'  => 'Class[Supervisor::Update]'
        )
      end

      it do
        is_expected.to contain_service('supervisor::test').with(
          'ensure'   => 'running',
          'provider' => 'base',
          'restart'  => '/usr/bin/supervisorctl restart test',
          'start'    => '/usr/bin/supervisorctl start test',
          'status'   => "/usr/bin/supervisorctl status | awk '/^test[: ]/{print \$2}' | grep '^RUNNING$'",
          'stop'     => '/usr/bin/supervisorctl stop test',
          'require'  => 'File[/etc/supervisord.d/test.ini]'
        )
      end
    end
  end
end
