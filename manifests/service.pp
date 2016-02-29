# == Class: percona::service
#
# Enabled the (mysql) service
#
class percona::service {
  $service_name   = $percona::service_name
  $service_enable = $percona::service_enable
  $service_ensure = $percona::service_ensure
  $mode           = $percona::mode
  $master         = $percona::master

  if $master {
    service { $service_name:
      ensure  => $service_ensure,
      alias   => 'mysql',
      require => [
        Class["percona::config::${mode}"],
        Class['percona::install'],
      ]
    }
  }else{
    service { $service_name:
      ensure  => $service_ensure,
      alias   => 'mysql',
      enable  => $service_enable,
      require => [
        Class["percona::config::${mode}"],
        Class['percona::install'],
      ]
    }
  }
}
