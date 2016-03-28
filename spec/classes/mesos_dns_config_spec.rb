require 'spec_helper'

describe 'mesos_dns::config' do
  context 'with default parameters' do
    it { is_expected.to compile.with_all_deps }

    directory_parameters = {
        :ensure => 'directory',
        :path => '/etc/mesos-dns',
        :owner => 'root',
        :group => 'root',
        :mode => '0640',
    }

    it { is_expected.to contain_file('mesos_dns_config_dir').with(directory_parameters) }

    json =<<-eof
{
  "zk": "zk://localhost:2181/mesos",
  "masters": [
    "localhost:5050"
  ],
  "zkDetectionTimeout": 30,
  "refreshSeconds": 60,
  "ttl": 60,
  "domain": "mesos",
  "port": 53,
  "httpport": 8123,
  "resolvers": [
    "8.8.8.8",
    "8.8.4.4"
  ],
  "timeout": 5,
  "httpon": true,
  "dnson": true,
  "externalon": true,
  "listener": "0.0.0.0",
  "SOAMname": "ns1.mesos",
  "SOARname": "root.ns1.mesos",
  "SOARefresh": 60,
  "SOARetry": 600,
  "SOAExpire": 86400,
  "SOAMinttl": 60,
  "recurseon": true,
  "enforceRFC952": false,
  "IPSources": [
    "netinfo",
    "mesos",
    "host"
  ]
}
    eof

    config_parameters = {
        :ensure => 'present',
        :path => '/etc/mesos-dns/config.json',
        :owner => 'root',
        :group => 'root',
        :mode => '0640',
        :content => json,
    }

    it { is_expected.to contain_file('mesos_dns_config_file').with(config_parameters) }

  end

  context 'with custom parameters' do
    let(:params) do
      {
          :zk_servers => %w(user:pass@zk1:2180 zk2),
          :zk_default_port => '2182',
          :zk_mesos_path => 'my-mesos',

          :mesos_masters => %w(n1 n2),
          :mesos_port => '5051',

          :config_dir_path => '/usr/local/etc/mesos-dns',
          :config_file_path => '/usr/local/etc/mesos-dns/config.json',
          :config_file_mode => '0600',

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

    directory_parameters = {
        :ensure => 'directory',
        :path => '/usr/local/etc/mesos-dns',
        :owner => 'root',
        :group => 'root',
        :mode => '0600',
    }

    it { is_expected.to contain_file('mesos_dns_config_dir').with(directory_parameters) }

    json =<<-eof
{
  "zk": "zk://user:pass@zk1:2180,zk2:2182/my-mesos",
  "masters": [
    "n1:5051",
    "n2:5051"
  ],
  "zkDetectionTimeout": 31,
  "refreshSeconds": 61,
  "ttl": 61,
  "domain": "my.mesos.local",
  "port": 54,
  "httpport": 8124,
  "resolvers": [
    "192.168.0.1"
  ],
  "timeout": 6,
  "httpon": false,
  "dnson": false,
  "externalon": false,
  "listener": "127.0.0.1",
  "SOAMname": "ns2.my.mesos.local",
  "SOARname": "admin.ns2.my.mesos.local",
  "SOARefresh": 61,
  "SOARetry": 601,
  "SOAExpire": 86401,
  "SOAMinttl": 61,
  "recurseon": false,
  "enforceRFC952": true,
  "IPSources": [
    "host"
  ]
}
    eof

    config_parameters = {
        :ensure => 'present',
        :path => '/usr/local/etc/mesos-dns/config.json',
        :owner => 'root',
        :group => 'root',
        :mode => '0600',
        :content => json,
    }

    it { is_expected.to contain_file('mesos_dns_config_file').with(config_parameters) }

  end

  context 'without zk_servers' do
    let(:params) do
      {
          :zk_servers => [],
          :mesos_masters => [],
      }
    end

    json =<<-eof
{
  "zkDetectionTimeout": 30,
  "refreshSeconds": 60,
  "ttl": 60,
  "domain": "mesos",
  "port": 53,
  "httpport": 8123,
  "resolvers": [
    "8.8.8.8",
    "8.8.4.4"
  ],
  "timeout": 5,
  "httpon": true,
  "dnson": true,
  "externalon": true,
  "listener": "0.0.0.0",
  "SOAMname": "ns1.mesos",
  "SOARname": "root.ns1.mesos",
  "SOARefresh": 60,
  "SOARetry": 600,
  "SOAExpire": 86400,
  "SOAMinttl": 60,
  "recurseon": true,
  "enforceRFC952": false,
  "IPSources": [
    "netinfo",
    "mesos",
    "host"
  ]
}
    eof

    config_parameters = {
        :ensure => 'present',
        :path => '/etc/mesos-dns/config.json',
        :owner => 'root',
        :group => 'root',
        :mode => '0640',
        :content => json,
    }

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('mesos_dns_config_file').with(config_parameters) }

  end
end
