require 'spec_helper'

describe 'mesos_dns::startup', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) { facts }

      context 'with Upstart system' do

        let(:params) do
          {
              :startup_manage => true,
              :binary_file_path => '/usr/local/bin/mesos-dns',
              :config_file_path => '/usr/local/etc/mesos-dns/config.json',
              :service_name => 'my-mesos-dns',
              :startup_system => 'upstart',
              :run_user => 'user',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('mesos_dns::startup::upstart') }

        upstart_content = <<-eof
description "Mesos DNS service"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5

setuid user

exec /usr/local/bin/mesos-dns -config /usr/local/etc/mesos-dns/config.json
        eof

        upstart_parameters = {
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :content => upstart_content,
            :path => '/etc/init/my-mesos-dns.conf',
        }


        it { is_expected.to contain_file('mesos_dns_init').with(upstart_parameters) }

        init_d_parameters = {
            :ensure => 'symlink',
            :target => '/lib/init/upstart-job',
            :path => '/etc/init.d/my-mesos-dns',
        }

        it { is_expected.to contain_file('mesos_dns_init.d').with(init_d_parameters) }

      end

      context 'with Systemd system' do

        let(:params) do
          {
              :startup_manage => true,
              :binary_file_path => '/usr/local/bin/mesos-dns',
              :config_file_path => '/usr/local/etc/mesos-dns/config.json',
              :service_name => 'my-mesos-dns',
              :startup_system => 'systemd',
              :run_user => 'user',
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('mesos_dns::startup::systemd') }

        systemd_content = <<-eof
[Unit]
Description=Mesos DNS service
After=network.target
Wants=network.target

[Service]
ExecStart=/usr/local/bin/mesos-dns -config /usr/local/etc/mesos-dns/config.json
Restart=on-abort
Restart=always
RestartSec=20

User=user

[Install]
WantedBy=multi-user.target
        eof

        systemd_parameters = {
            :ensure => 'present',
            :owner => 'root',
            :group => 'root',
            :mode => '0644',
            :content => systemd_content,
            :path => '/lib/systemd/system/my-mesos-dns.service',
        }

        it { is_expected.to contain_file('mesos_dns_systemd_unit').with(systemd_parameters) }

      end

      context 'when startup_manage is disabled' do

        let(:params) do
          {
              :startup_manage => false,
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_file('mesos_dns_init') }

        it { is_expected.not_to contain_file('mesos_dns_init.d') }

        it { is_expected.not_to contain_file('mesos_dns_systemd_unit') }

      end
    end

  end
end
