require 'spec_helper'

describe 'mesos_dns::startup' do
  context 'on a Ubuntu system' do
    let(:facts) do
      {
          :operatingsystem => 'Ubuntu',
      }
    end

    context 'with default parameters and service_manage enabled' do

      let(:params) do
        {
            :startup_manage => true,
        }
      end

      it { is_expected.to compile.with_all_deps }

      upstart_init = <<-eof
description "DNS service for Mesos"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5

exec /usr/bin/mesos-dns -config /etc/mesos-dns/config.json
      eof

      init_parameters = {
          :ensure => 'present',
          :owner => 'root',
          :group => 'root',
          :mode => '0644',
          :content => upstart_init,
          :path => '/etc/init/mesos-dns.conf',
      }


      it { is_expected.to contain_file('mesos-dns-init').with(init_parameters) }

      init_d_parameters = {
          :ensure => 'symlink',
          :target => '/lib/init/upstart-job',
          :path => '/etc/init.d/mesos-dns',
      }

      it { is_expected.to contain_file('mesos-dns-init.d').with(init_d_parameters) }

    end

    context 'with custom parameters' do

      let(:params) do
        {
            :startup_manage => true,
            :binary_file_path => '/usr/local/bin/mesos-dns',
            :config_file_path => '/usr/local/etc/mesos-dns/config.json',
            :service_name => 'my-mesos-dns',
        }
      end

      it { is_expected.to compile.with_all_deps }

      upstart_init = <<-eof
description "DNS service for Mesos"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5

exec /usr/local/bin/mesos-dns -config /usr/local/etc/mesos-dns/config.json
      eof

      init_parameters = {
          :ensure => 'present',
          :owner => 'root',
          :group => 'root',
          :mode => '0644',
          :content => upstart_init,
          :path => '/etc/init/my-mesos-dns.conf',
      }


      it { is_expected.to contain_file('mesos-dns-init').with(init_parameters) }

      init_d_parameters = {
          :ensure => 'symlink',
          :target => '/lib/init/upstart-job',
          :path => '/etc/init.d/my-mesos-dns',
      }

      it { is_expected.to contain_file('mesos-dns-init.d').with(init_d_parameters) }

    end

    context 'when startup_manage is disabled' do

      let(:params) do
        {
            :startup_manage => false,
        }
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.not_to contain_file('mesos-dns-init') }

      it { is_expected.not_to contain_file('mesos-dns-init.d') }

    end
  end
end
