class mesos_dns::params {
  $package_manage   = true
  $package_ensure   = 'present'
  $package_name     = 'mesos-dns'
  $package_provider = undef

  $service_enable   = true
  $service_manage   = true
  $service_name     = 'mesos-dns'
  $service_provider = undef

  $zk_servers       = ['localhost']
  $zk_mesos_path    = 'mesos'
  $zk_default_port  = '2181'

  $mesos_masters    = ['localhost']
  $mesos_port       = '5050'

  $config_dir_path      = '/etc/mesos-dns'
  $config_file_path     = '/etc/mesos-dns/config.json'
  $config_file_mode     = '0640'

  $binary_file_path     = '/usr/bin/mesos-dns'

  $startup_manage       = false

  $zk_detection_timeout = '30'
  $refresh_seconds      = '60'
  $ttl                  = '60'
  $domain               = 'mesos'
  $port                 = '53'
  $resolvers            = ['8.8.8.8', '8.8.4.4']
  $timeout              = '5'
  $http_on              = true
  $dns_on               = true
  $external_on          = true
  $http_port            = '8123'
  $listener             = '0.0.0.0'
  $soa_master_name      = 'ns1.mesos'
  $soa_mail_name        = 'root.ns1.mesos'
  $soa_refresh          = '60'
  $soa_retry            = '600'
  $soa_expire           = '86400'
  $soa_min_ttl          = '60'
  $recurse_on           = true
  $enforce_rfc952       = false
  $ip_sources           = ['netinfo', 'mesos', 'host']
}
