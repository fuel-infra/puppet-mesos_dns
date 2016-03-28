class mesos_dns::service (
  $service_manage   = $mesos_dns::params::service_manage,
  $service_enable   = $mesos_dns::params::service_enable,
  $service_name     = $mesos_dns::params::service_name,
  $service_provider = $mesos_dns::params::service_provider,
) inherits ::mesos_dns::params {
  validate_bool($service_manage)
  validate_bool($service_enable)
  validate_string($service_name)

  if $service_provider {
    validate_string($service_provider)
  }

  if $service_manage {

    if $service_enable {
      $ensure_service = 'running'
    } else {
      $ensure_service = 'stopped'
    }

    service { 'mesos-dns' :
      ensure     => $ensure_service,
      name       => $service_name,
      hasstatus  => true,
      hasrestart => true,
      enable     => $service_enable,
      provider   => $service_provider,
    }

  }

}
