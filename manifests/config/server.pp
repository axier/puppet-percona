class percona::config::server {
  $config_file        = $::percona::config_file
  $config_file_mode   = $::percona::config_file_mode
  $purge_includedir   = $::percona::purge_includedir
  $config_includedir  = $::percona::config_includedir
  $config_user        = $::percona::config_user
  $config_group       = $::percona::config_group

  $daemon_user        = $::percona::daemon_user
  $logdir             = $::percona::logdir
  $logdir_group       = $::percona::logdir_group
  $service_name       = $::percona::service_name
  $service_restart    = $::percona::service_restart
  $template           = $::percona::template
  $version            = $::percona::percona_version

  $default_config     = $::percona::default_config
  $custom_config      = $::percona::custom_config
  $manage_config_file = $::percona::manage_config_file


  $options = percona_hash_merge($default_config, $custom_config)

  File {
    owner   => $config_user,
    group   => $config_group,
    require => [
      Class['percona::install'],
    ],
  }

  if $config_includedir and $config_includedir != '' {
    file { $config_includedir:
      ensure  => directory,
      recurse => $purge_includedir,
      purge   => $purge_includedir,
      mode    => $::percona::config_include_dir_mode,
    }
  }

  if $::percona::manage_config_file {
    file { $config_file:
      path                    => $config_file,
      ensure                  => 'present',
      content                 => template("percona/${::percona::mode}/my.cnf.erb"),
      mode                    => $::percona::config_file_mode,
      selinux_ignore_defaults => true,
      notify => [
        Class['percona::service'],
      ],
    }
  }

}

