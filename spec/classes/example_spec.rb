require 'spec_helper'

describe 'role_ids' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "role_ids class with monitor_interface set to eth0" do
          let(:params) { {:monitor_interface => "eth0"} }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('role_ids') }
          it { is_expected.to contain_class('suricata').that_comes_before('scirius')  }
          it { is_expected.to contain_class('scirius') }
          it { is_expected.to contain_logrotate__rule('suricata') }

        end
      end
    end
  end
end
