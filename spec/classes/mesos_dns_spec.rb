require 'spec_helper'

describe 'mesos_dns', :type => :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do

      let(:facts) { facts }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('mesos_dns') }

        it { is_expected.to contain_class('mesos_dns::params') }

        config_parameters = {
            :zk_servers => %w(localhost),
            :zk_default_port => '2181',
            :zk_mesos_path => 'mesos',

            :mesos_masters => %w(localhost),
            :mesos_port => '5050',

            :config_dir_path => '/etc/mesos-dns',
            :config_file_path => '/etc/mesos-dns/config.json',
            :config_file_mode => '0640',

            :zk_detection_timeout => '30',
            :refresh_seconds => '60',
            :ttl => '60',
            :domain => 'mesos',
            :port => '53',
            :resolvers => %w(8.8.8.8 8.8.4.4),
            :timeout => '5',
            :http_on => true,
            :dns_on => true,
            :external_on => true,
            :http_port => '8123',
            :listener => '0.0.0.0',
            :soa_master_name => 'ns1.mesos',
            :soa_mail_name => 'root.ns1.mesos',
            :soa_refresh => '60',
            :soa_retry => '600',
            :soa_expire => '86400',
            :soa_min_ttl => '60',
            :recurse_on => true,
            :enforce_rfc952 => false,
            :ip_sources => %w(netinfo mesos host),
        }

        it { is_expected.to contain_class('mesos_dns::config').with(config_parameters) }

        install_parameters = {
            :package_manage => true,
            :package_name => 'mesos-dns',
            :package_ensure => 'present',
        }

        it { is_expected.to contain_class('mesos_dns::install').with(install_parameters) }

        startup_parameters = {
            :config_file_path => '/etc/mesos-dns/config.json',
            :binary_file_path => '/usr/bin/mesos-dns',
            :startup_manage => false,
            :service_name => 'mesos-dns',
        }

        it { is_expected.to contain_class('mesos_dns::startup').with(startup_parameters) }

        service_parameters = {
            :service_manage => true,
            :service_name => 'mesos-dns',
            :service_enable => true,
        }

        it { is_expected.to contain_class('mesos_dns::service').with(service_parameters) }
      end

      context 'with custom parameters' do
        let(:params) do
          {
              :package_manage => false,
              :package_ensure => 'latest',
              :package_name => 'my-mesos-dns',
              :package_provider => 'pip',

              :service_enable => false,
              :service_manage => false,
              :service_name => 'my-mesos-dns',
              :service_provider => 'systemd',

              :zk_servers => %w(zk1 zk2),
              :zk_mesos_path => 'my-mesos',
              :zk_default_port => '2182',

              :mesos_masters => %w(zk3 zk4),
              :mesos_port => '5051',

              :config_file_path => '/usr/local/etc/mesos-dns/config.json',
              :config_dir_path => '/usr/local/etc/mesos-dns',
              :config_file_mode => '0600',

              :startup_manage => true,
              :startup_system => 'systemd',
              :binary_file_path => '/usr/local/bin/mesos-dns',
              :run_user => 'user',
              :run_group => 'group',

              :zk_detection_timeout => '31',
              :refresh_seconds => '61',
              :ttl => '61',
              :domain => 'my.mesos.local',
              :port => '54',
              :resolvers => ['192.168.0.1'],
              :timeout => '6',
              :http_on => false,
              :dns_on => false,
              :external_on => false,
              :http_port => '8124',
              :listener => '127.0.0.1',
              :soa_master_name => 'ns2.my.mesos.local',
              :soa_mail_name => 'admin.ns2.my.mesos.local',
              :soa_refresh => '61',
              :soa_retry => '601',
              :soa_expire => '86401',
              :soa_min_ttl => '61',
              :recurse_on => false,
              :enforce_rfc952 => true,
              :ip_sources => ['host'],
          }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('mesos_dns') }

        it { is_expected.to contain_class('mesos_dns::params') }

        config_parameters = {
            :zk_servers => %w(zk1 zk2),
            :zk_default_port => '2182',
            :zk_mesos_path => 'my-mesos',

            :mesos_masters => %w(zk3 zk4),
            :mesos_port => '5051',

            :config_dir_path => '/usr/local/etc/mesos-dns',
            :config_file_path => '/usr/local/etc/mesos-dns/config.json',
            :config_file_mode => '0600',

            :zk_detection_timeout => '31',
            :refresh_seconds => '61',
            :ttl => '61',
            :domain => 'my.mesos.local',
            :port => '54',
            :resolvers => %w(192.168.0.1),
            :timeout => '6',
            :http_on => false,
            :dns_on => false,
            :external_on => false,
            :http_port => '8124',
            :listener => '127.0.0.1',
            :soa_master_name => 'ns2.my.mesos.local',
            :soa_mail_name => 'admin.ns2.my.mesos.local',
            :soa_refresh => '61',
            :soa_retry => '601',
            :soa_expire => '86401',
            :soa_min_ttl => '61',
            :recurse_on => false,
            :enforce_rfc952 => true,
            :ip_sources => %w(host),
        }

        it { is_expected.to contain_class('mesos_dns::config').with(config_parameters) }

        install_parameters = {
            :package_manage => false,
            :package_name => 'my-mesos-dns',
            :package_ensure => 'latest',
            :package_provider => 'pip'
        }

        it { is_expected.to contain_class('mesos_dns::install').with(install_parameters) }

        startup_parameters = {
            :config_file_path => '/usr/local/etc/mesos-dns/config.json',
            :binary_file_path => '/usr/local/bin/mesos-dns',
            :startup_manage => true,
            :service_name => 'my-mesos-dns',
            :startup_system => 'systemd',
            :run_user => 'user',
            :run_group => 'group',
        }

        it { is_expected.to contain_class('mesos_dns::startup').with(startup_parameters) }

        service_parameters = {
            :service_enable => false,
            :service_manage => false,
            :service_name => 'my-mesos-dns',
            :service_provider => 'systemd',
        }

        it { is_expected.to contain_class('mesos_dns::service').with(service_parameters) }
      end

    end
  end
end
