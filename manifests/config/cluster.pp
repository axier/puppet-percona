class percona::config::cluster {

  $config_file        = $::percona::config_file
  $config_file_mode   = $::percona::config_file_mode
  $purge_includedir   = $::percona::purge_includedir
  $config_includedir  = $::percona::config_includedir
  $config_user        = $::percona::config_user
  $config_group       = $::percona::config_group
  $config_replace     = $::percona::config_replace
  $config_skip        = $::percona::config_skip

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

  $wsrep_sst_method   = $percona::wsrep_sst_method
  $wsrep_sst_user     = $percona::wsrep_sst_user
  $wsrep_sst_password = $percona::wsrep_sst_password


  case $wsrep_sst_method {
    'mysqldump': {
      $sst_method_config = {
        'mysqld' => {
          'wsrep_sst_method' => 'mysqldump',
        },
      }
    }
    'xtrabackup-v2': {
      $sst_method_config = {
        'mysqld' => {
          'wsrep_sst_method' => 'xtrabackup-v2',
          'wsrep_sst_auth'   => "${wsrep_sst_user}:${wsrep_sst_password}"
        },
      }
      include percona::sst_auth

      Class['percona::root_password'] -> Class['percona::sst_auth'] -> Anchor['percona::end']
    }
    default: {
      $sst_method_config = {
        'mysqld' => {
          'wsrep_sst_method' => 'rsync',
        },
      }
    }
  }

  $options = percona_hash_merge($default_config, $sst_method_config, $custom_config)

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
