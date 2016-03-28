class mesos_dns::startup::upstart (
  $binary_file_path = $mesos_dns::params::binary_file_path,
  $config_file_path = $mesos_dns::params::config_file_path,
  $service_name     = $mesos_dns::params::service_name,
  $run_user         = $mesos_dns::params::run_user,
  $run_group        = $mesos_dns::params::run_group,
) inherits ::mesos_dns::params {

  file { 'mesos_dns_init' :
    ensure  => 'present',
    path    => "/etc/init/${service_name}.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('mesos_dns/startup/upstart.conf.erb'),
  }

  file { 'mesos_dns_init.d' :
    ensure => 'symlink',
    path   => "/etc/init.d/${service_name}",
    target => '/lib/init/upstart-job',
  }

  File['mesos_dns_init'] ~>
  Service <| title == 'mesos-dns' |>

  File['mesos_dns_init.d'] ~>
  Service <| title == 'mesos-dns' |>

}
