require 'spec_helper'

describe 'supervisor::update', :type => :class do
  on_supported_os.each do |os,facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'default params' do
        it do
          is_expected.to contain_exec('supervisor::update').with(
            'command'     => '/usr/bin/supervisorctl update',
            'logoutput'   => 'on_failure',
            'refreshonly' => true,
            'require'     => 'Service[supervisord]'
          )
        end
      end
    end
  end
end
