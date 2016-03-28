class mesos_dns::config (
  $zk_servers       = $mesos_dns::params::zk_servers,
  $zk_mesos_path    = $mesos_dns::params::zk_mesos_path,
  $zk_default_port  = $mesos_dns::params::zk_default_port,

  $mesos_masters    = $mesos_dns::params::mesos_masters,
  $mesos_port       = $mesos_dns::params::mesos_port,

  $config_dir_path  = $mesos_dns::params::config_dir_path,
  $config_file_path = $mesos_dns::params::config_file_path,
  $config_file_mode = $mesos_dns::params::config_file_mode,

  $zk_detection_timeout = $mesos_dns::params::zk_detection_timeout,
  $refresh_seconds      = $mesos_dns::params::refresh_seconds,
  $ttl                  = $mesos_dns::params::ttl,
  $domain               = $mesos_dns::params::domain,
  $port                 = $mesos_dns::params::port,
  $http_port            = $mesos_dns::params::http_port,
  $resolvers            = $mesos_dns::params::resolvers,
  $timeout              = $mesos_dns::params::timeout,
  $http_on              = $mesos_dns::params::http_on,
  $dns_on               = $mesos_dns::params::dns_on,
  $external_on          = $mesos_dns::params::external_on,
  $listener             = $mesos_dns::params::listener,
  $soa_master_name      = $mesos_dns::params::soa_master_name,
  $soa_mail_name        = $mesos_dns::params::soa_mail_name,
  $soa_refresh          = $mesos_dns::params::soa_refresh,
  $soa_retry            = $mesos_dns::params::soa_retry,
  $soa_expire           = $mesos_dns::params::soa_expire,
  $soa_min_ttl          = $mesos_dns::params::soa_min_ttl,
  $recurse_on           = $mesos_dns::params::recurse_on,
  $enforce_rfc952       = $mesos_dns::params::enforce_rfc952,
  $ip_sources           = $mesos_dns::params::ip_sources,
) inherits ::mesos_dns::params {
  validate_array($zk_servers)
  validate_array($mesos_masters)
  validate_string($zk_mesos_path)
  validate_integer($zk_default_port)
  validate_integer($mesos_port)
  validate_absolute_path($config_dir_path)
  validate_absolute_path($config_file_path)
  validate_string($config_file_mode)

  validate_integer($zk_detection_timeout)
  validate_integer($refresh_seconds)
  validate_integer($ttl)
  validate_string($domain)
  validate_integer($port)
  validate_integer($http_port)
  validate_array($resolvers)
  validate_integer($timeout)
  validate_bool($http_on)
  validate_bool($dns_on)
  validate_bool($external_on)
  validate_ip_address($listener)
  validate_string($soa_master_name)
  validate_string($soa_mail_name)
  validate_integer($soa_refresh)
  validate_integer($soa_retry)
  validate_integer($soa_expire)
  validate_integer($soa_min_ttl)
  validate_bool($recurse_on)
  validate_bool($enforce_rfc952)
  validate_array($ip_sources)

  File {
    owner => 'root',
    group => 'root',
    mode  => $config_file_mode,
  }

  file { 'mesos_dns_config_dir' :
    ensure => 'directory',
    path   => $config_dir_path,
  }

  $zk_url = mesos_dns_zk_url($zk_servers, $zk_mesos_path, $zk_default_port)
  $masters_list = mesos_dns_masters($mesos_masters, $mesos_port)

  file { 'mesos_dns_config_file' :
    ensure  => 'present',
    path    => $config_file_path,
    content => template('mesos_dns/config.json.erb'),
  }

  File['mesos_dns_config_file'] ~>
  Service <| title == 'mesos-dns' |>

}
