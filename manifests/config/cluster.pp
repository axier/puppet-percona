class percona::config::cluster {

  $config_content     = $::percona::config_content
  $config_dir         = $::percona::config_dir
  $config_dir_mode    = $::percona::config_dir_mode
  $config_file        = $::percona::config_file
  $config_file_mode   = $::percona::config_file_mode
  $config_group       = $::percona::config_group
  $purge_includedir   = $::percona::purge_includedir
  $config_includedir  = $::percona::config_includedir
  $config_user        = $::percona::config_user
  $config_group       = $::percona::paramas::
  $config_replace     = $::percona::config_replace
  $config_skip        = $::percona::config_skip

  $daemon_user        = $::percona::daemon_user
  $logdir             = $::percona::logdir
  $logdir_group       = $::percona::logdir_group
  $service_name       = $::percona::service_name
  $service_restart    = $::percona::service_restart
  $template           = $::percona::template
  $version            = $::percona::percona_version

  $default_config     = $::percona::params::default_options
  $override_options   = $::percona::override_options
  $manage_config_file = $::percona::manage_config_file


  $options = mysql_deepmerge($default_config, $override_options)

  File {
    owner   => $config_user,
    group   => $config_group,
    mode    => $config_dir_mode,
    require => [
      Class['percona::install'],
    ],
  }
  if $service_restart {
    File {
      notify => Service[$service_name],
    }
  }

  if $config_includedir and $config_includedir != '' {
    file { $config_includedir:
      ensure  => directory,
      recurse => $purge_includedir,
      purge   => $purge_includedir,
    }
  }

  if $::percona::manage_config_file {
    file { $config_file:
      path    => $::percona::parameters::config_file
      ensure  => 'present',
      content => template('percona/${::percona::package}/my.cnf.erb'),
      selinux_ignore_defaults => true,
    }
  }


  if $service_restart {
    File {
      notify => Service[$service_name],
    }
  }
}
