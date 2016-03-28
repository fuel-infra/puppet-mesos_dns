class mesos_dns::startup::systemd (
  $binary_file_path = $mesos_dns::params::binary_file_path,
  $config_file_path = $mesos_dns::params::config_file_path,
  $service_name     = $mesos_dns::params::service_name,
  $run_user         = $mesos_dns::params::run_user,
  $run_group        = $mesos_dns::params::run_group,
) inherits ::mesos_dns::params {

  File {
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { 'mesos_dns_systemd_unit' :
    path    => "/lib/systemd/system/${service_name}.service",
    content => template('mesos_dns/startup/systemd.unit.erb'),
  }

  File['mesos_dns_systemd_unit'] ~>
  Service <| title == 'mesos_dns' |>

}
