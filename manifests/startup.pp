class mesos_dns::startup (
  $startup_manage   = $mesos_dns::params::startup_manage,
  $binary_file_path = $mesos_dns::params::binary_file_path,
  $config_file_path = $mesos_dns::params::config_file_path,
  $service_name     = $mesos_dns::params::service_name,
) inherits ::mesos_dns::params {
  validate_bool($startup_manage)
  validate_string($service_name)
  validate_absolute_path($binary_file_path)
  validate_absolute_path($config_file_path)

  if $startup_manage {

    if $::operatingsystem == 'Ubuntu' {
      file { 'mesos-dns-init' :
        ensure  => 'present',
        path    => "/etc/init/${service_name}.conf",
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('mesos_dns/upstart.erb'),
      }

      file { 'mesos-dns-init.d' :
        ensure => 'symlink',
        path   => "/etc/init.d/${service_name}",
        target => '/lib/init/upstart-job',
      }

      File['mesos-dns-init'] ~>
      Service <| title == 'mesos-dns' |>

      File['mesos-dns-init.d'] ~>
      Service <| title == 'mesos-dns' |>
    }

  }

}
