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

          # should compile
          it { is_expected.to compile.with_all_deps }

          # contain classes
          it { is_expected.to contain_class('role_ids') }
          it { is_expected.to contain_class('suricata').that_comes_before('scirius')  }
          it { is_expected.to contain_class('scirius') }

          # contain packages
          it { is_expected.to contain_package('suricata') }
          it { is_expected.to contain_package('ethtool') }
          it { is_expected.to contain_package('libhtp1') }
          it { is_expected.to contain_package('python-pyinotify') }
          it { is_expected.to contain_package('python-software-properties') }
          it { is_expected.to contain_package('software-properties-common') }
          it { is_expected.to contain_package('git') }
          it { is_expected.to contain_package('expect') }
          it { is_expected.to contain_package('python-dev') }
          it { is_expected.to contain_package('python-django') }
          it { is_expected.to contain_package('python-docutils') }
          it { is_expected.to contain_package('python-imaging') }
          it { is_expected.to contain_package('python-markdown') }
          it { is_expected.to contain_package('python-pip') }
          it { is_expected.to contain_package('python-pyinotify') }
          it { is_expected.to contain_package('python-pythonmagick') }
          it { is_expected.to contain_package('python-textile') }
          it { is_expected.to contain_package('south') }

          # contain logrotate rule
          it { is_expected.to contain_logrotate__rule('suricata') }

        end
      end
    end
  end
end
