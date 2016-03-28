class mesos_dns::startup (
  $startup_manage   = $mesos_dns::params::startup_manage,
  $binary_file_path = $mesos_dns::params::binary_file_path,
  $config_file_path = $mesos_dns::params::config_file_path,
  $service_name     = $mesos_dns::params::service_name,
  $startup_system   = $mesos_dns::params::startup_system,
  $run_user         = $mesos_dns::params::run_user,
  $run_group        = $mesos_dns::params::run_group,
) inherits ::mesos_dns::params {
  validate_bool($startup_manage)
  validate_string($service_name)
  validate_absolute_path($binary_file_path)
  validate_absolute_path($config_file_path)

  if $startup_manage {

    if $startup_system == 'upstart' {

      class { 'mesos_dns::startup::upstart' :
        binary_file_path => $binary_file_path,
        config_file_path => $config_file_path,
        service_name     => $service_name,
        run_user         => $run_user,
        run_group        => $run_group,
      }

      contain 'mesos_dns::startup::upstart'

    } elsif $startup_system == 'systemd' {

      class { 'mesos_dns::startup::systemd' :
        binary_file_path => $binary_file_path,
        config_file_path => $config_file_path,
        service_name     => $service_name,
        run_user         => $run_user,
        run_group        => $run_group,
      }

      contain 'mesos_dns::startup::systemd'

    }

  }

}
