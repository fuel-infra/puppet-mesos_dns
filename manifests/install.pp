class mesos_dns::install (
  $package_manage   = $mesos_dns::params::package_manage,
  $package_ensure   = $mesos_dns::params::package_ensure,
  $package_name     = $mesos_dns::params::package_name,
  $package_provider = $mesos_dns::params::package_provider,
) inherits ::mesos_dns::params {
  validate_bool($package_manage)
  validate_string($package_ensure)
  validate_string($package_name)

  if $package_provider {
    validate_string($package_provider)
  }

  if $package_manage {

    package { 'mesos-dns' :
      ensure   => $package_ensure,
      name     => $package_name,
      provider => $package_provider,
    }

    Package['mesos-dns'] ~>
    Service <| title == 'mesos-dns' |>

  }

}
