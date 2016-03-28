class mesos_dns (
  $package_manage       = $mesos_dns::params::package_manage,
  $package_ensure       = $mesos_dns::params::package_ensure,
  $package_name         = $mesos_dns::params::package_name,
  $package_provider     = $mesos_dns::params::package_provider,

  $service_enable       = $mesos_dns::params::service_enable,
  $service_manage       = $mesos_dns::params::service_manage,
  $service_name         = $mesos_dns::params::service_name,
  $service_provider     = $mesos_dns::params::service_provider,

  $startup_manage       = $mesos_dns::params::startup_manage,

  $zk_servers           = $mesos_dns::params::zk_servers,
  $zk_mesos_path        = $mesos_dns::params::zk_mesos_path,
  $zk_default_port      = $mesos_dns::params::zk_default_port,

  $mesos_masters        = $mesos_dns::params::mesos_masters,
  $mesos_port           = $mesos_dns::params::mesos_port,

  $config_file_path     = $mesos_dns::params::config_file_path,
  $config_dir_path      = $mesos_dns::params::config_dir_path,
  $config_file_mode     = $mesos_dns::params::config_file_mode,

  $binary_file_path     = $mesos_dns::params::binary_file_path,

  $zk_detection_timeout = $mesos_dns::params::zk_detection_timeout,
  $refresh_seconds      = $mesos_dns::params::refresh_seconds,
  $ttl                  = $mesos_dns::params::ttl,
  $domain               = $mesos_dns::params::domain,
  $port                 = $mesos_dns::params::port,
  $resolvers            = $mesos_dns::params::resolvers,
  $timeout              = $mesos_dns::params::timeout,
  $http_on              = $mesos_dns::params::http_on,
  $dns_on               = $mesos_dns::params::dns_on,
  $http_port            = $mesos_dns::params::http_port,
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

  class { '::mesos_dns::install' :
    package_manage   => $package_manage,
    package_ensure   => $package_ensure,
    package_name     => $package_name,
    package_provider => $package_provider,
  }

  class { '::mesos_dns::config' :
    zk_servers           => $zk_servers,
    zk_default_port      => $zk_default_port,
    zk_mesos_path        => $zk_mesos_path,

    mesos_masters        => $mesos_masters,
    mesos_port           => $mesos_port,

    config_dir_path      => $config_dir_path,
    config_file_path     => $config_file_path,
    config_file_mode     => $config_file_mode,

    zk_detection_timeout => $zk_detection_timeout,
    refresh_seconds      => $refresh_seconds,
    ttl                  => $ttl,
    domain               => $domain,
    port                 => $port,
    resolvers            => $resolvers,
    timeout              => $timeout,
    http_on              => $http_on,
    dns_on               => $dns_on,
    http_port            => $http_port,
    external_on          => $external_on,
    listener             => $listener,
    soa_master_name      => $soa_master_name,
    soa_mail_name        => $soa_mail_name,
    soa_refresh          => $soa_refresh,
    soa_retry            => $soa_retry,
    soa_expire           => $soa_expire,
    soa_min_ttl          => $soa_min_ttl,
    recurse_on           => $recurse_on,
    enforce_rfc952       => $enforce_rfc952,
    ip_sources           => $ip_sources,
  }

  class { '::mesos_dns::startup' :
    startup_manage   => $startup_manage,
    binary_file_path => $binary_file_path,
    config_file_path => $config_file_path,
    service_name     => $service_name,
  }

  class { '::mesos_dns::service' :
    service_manage   => $service_manage,
    service_enable   => $service_enable,
    service_name     => $service_name,
    service_provider => $service_provider,
  }

  contain 'mesos_dns::install'
  contain 'mesos_dns::config'
  contain 'mesos_dns::startup'
  contain 'mesos_dns::service'

  Class['mesos_dns::install'] ->
  Class['mesos_dns::config'] ->
  Class['mesos_dns::startup'] ->
  Class['mesos_dns::service']
}
