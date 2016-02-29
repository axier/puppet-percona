class percona (
  $percona_version                = $percona::params::percona_version,
  $manage_repo                    = $percona::params::manage_repo,
  $mode                           = $percona::params::mode,
  $master                         = $percona::params::master,

  $config_file                    = $percona::params::default_config_file,
  $config_file_mode               = $percona::params::config_file_mode,
  $config_dir                     = $percona::params::config_dir,
  $config_dir_mode                = $percona::params::config_dir_mode,
  $config_include_dir             = $percona::params::config_include_dir,
  $config_include_dir_mode        = $percona::params::config_include_dir_mode,
  $config_user                    = $percona::params::config_user,
  $config_group                   = $percona::params::config_group,
  $manage_config_file             = $percona::params::manage_config_file,

  $service_enable                 = $percona::params::service_enable,
  $service_ensure                 = $percona::params::service_ensure,
  $service_restart                = $percona::params::service_restart,
  $daemon_group                   = $percona::params::daemon_group,
  $daemon_user                    = $percona::params::daemon_user,
  $pidfile                        = $percona::params::pidfile,
  $bind_address                   = $percona::params::bind_address,
  $port                           = $percona::params::port,
  $max_connections                = $percona::params::max_connections,

  $tmpdir                         = $percona::params::tmpdir,
  $logdir                         = $percona::params::logdir,
  $logdir_group                   = $percona::params::logdir_group,
  $socket                         = $percona::params::socket,
  $datadir                        = $percona::params::datadir,
  $errorlog                       = $percona::params::errorlog,

  $root_password                  = undef,
  $mgmt_cnf                       = $percona::params::mgmt_cnf,
  $users                   = {},
  $grants                  = {},
  $databases               = {},

  $mysql_user                     = $percona::params::mysql_user,
  $mysql_cluster_servers          = undef,

  $storage_engine                 = $percona::params::default_storage_engine,
  $binlog_format                  = $percona::params::binlog_format,
  $wsrep_provider                 = $percona::params::wsrep_provider,
  $wsrep_cluster_name             = $percona::params::wsrep_cluster_name,
  $wsrep_sst_method               = $percona::params::wsrep_sst_method,
  $wsrep_slave_threads            = $percona::params::wsrep_slave_threads,
  $wsrep_sst_user                 = undef,
  $wsrep_sst_password             = undef,

  $innodb_buffer_pool_size        = $percona::params::innodb_buffer_pool_size,
  $innodb_log_file_size           = $percona::params::innodb_log_file_size,
  $innodb_log_buffer_size         = $percona::params::innodb_log_buffer_size,
  $innodb_file_per_table          = $percona::params::innodb_file_per_table,
  $innodb_autoinc_lock_mode       = $percona::params::innodb_autoinc_lock_mode,
  $innodb_flush_log_at_trx_commit = $percona::params::innodb_flush_log_at_trx_commit,
  $innodb_support_xa              = $percona::params::innodb_support_xa,
  $innodb_doublewrite             = $percona::params::innodb_doublewrite,
  $innodb_flush_method            = $percona::params::innodb_flush_method,

  $query_cache_size               = $percona::params::query_cache_size,
  $query_cache_type               = $percona::params::query_cache_type,

  $symbolic_links                 = $percona::params::symbolic_links,
  $sync_binlog                    = $percona::params::sync_binlog,
  $log_bin                        = $percona::params::log_bin,

) inherits percona::params {

  validate_string($mysql_cluster_servers)

  $sanitized_servername = regsubst($::percona::servername,'\.','-','G')




  case $mode {
    'cluster': {
      $package_prefix = 'XtraDB-Cluster'
      $default_config  = {
        'mysqld' => {
          'basedir'                        => $basedir,
          'bind-address'                   => $bind_address,
          'datadir'                        => $datadir,
          'max_connections'                => $max_connections,
          'pid-file'                       => $pidfile,
          'port'                           => $port,
          'socket'                         => $socket,
          'tmpdir'                         => $tmpdir,
          'user'                           => $mysql_user,
          'wsrep_provider'                 => $wsrep_provider,
          'wsrep_cluster_address'          => "gcomm://${mysql_cluster_servers}",
          'binlog_format'                  => $binlog_format,
          'default_storage_engine'         => $storage_engine,
          'wsrep_node_address'             => $::fqdn,
          'wsrep_sst_method'               => $wsrep_sst_method,
          'wsrep_cluster_name'             => $wsrep_cluster_name,
          'wsrep_slave_threads'            => $wsrep_slave_threads,
          'innodb_buffer_pool_size'        => $percona::params::innodb_buffer_pool_size,
          'innodb_log_file_size'           => $percona::params::innodb_log_file_size,
          'innodb_log_buffer_size'         => $percona::params::innodb_log_buffer_size,
          'innodb_file_per_table'          => $innodb_file_per_table,
          'innodb_autoinc_lock_mode'       => $innodb_autoinc_lock_mode,
          'innodb_flush_log_at_trx_commit' => $innodb_flush_log_at_trx_commit,
          'innodb_support_xa'              => $innodb_support_xa,
          'innodb_doublewrite'             => $innodb_doublewrite,
          'innodb_flush_method'            => $innodb_flush_method,
          'query_cache_size'               => $query_cache_size,
          'query_cache_type'               => $query_cache_type,
          'sync_binlog'                    => $sync_binlog,
          'log-bin'                        => $log_bin,
          'symbolic_links'                 => $symbolic_links,
        },
        'mysqld_safe' => {
          'log-error' => $error_log,
          'socket'    => $socket,
        },
        'client' => {
          'port'   => $port,
          'socket' => $socket,
        },
      }
       if $master {
         $service_name = 'mysql@bootstrap'
      } else
      {
         $service_name = $percona::params::service_name
      }
    }
    'server': {
      $package_prefix = 'Server-server'
      $default_config  = {
        'mysqld' => {
          'basedir'                        => $basedir,
          'bind-address'                   => $bind_address,
          'datadir'                        => $datadir,
          'max_connections'                => $max_connections,
          'pid-file'                       => $pidfile,
          'port'                           => $port,
          'socket'                         => $socket,
          'tmpdir'                         => $tmpdir,
          'user'                           => $mysql_user,
          'binlog_format'                  => $binlog_format,
          'default_storage_engine'         => $storage_engine,
          'innodb_buffer_pool_size'        => $percona::params::innodb_buffer_pool_size,
          'innodb_log_file_size'           => $percona::params::innodb_log_file_size,
          'innodb_log_buffer_size'         => $percona::params::innodb_log_buffer_size,
          'innodb_file_per_table'          => $innodb_file_per_table,
          'innodb_autoinc_lock_mode'       => $innodb_autoinc_lock_mode,
          'innodb_flush_log_at_trx_commit' => $innodb_flush_log_at_trx_commit,
          'innodb_support_xa'              => $innodb_support_xa,
          'innodb_doublewrite'             => $innodb_doublewrite,
          'innodb_flush_method'            => $innodb_flush_method,
          'query_cache_size'               => $query_cache_size,
          'query_cache_type'               => $query_cache_type,
          'sync_binlog'                    => $sync_binlog,
          'log-bin'                        => $log_bin,
          'symbolic_links'                 => $symbolic_links,
        },
        'mysqld_safe' => {
          'log-error' => $error_log,
          'socket'    => $socket,
        },
        'client' => {
          'port'   => $port,
          'socket' => $socket,
        },
      }
      $service_name = $percona::params::service_name
    }
    'cluster_client': {
      $package_prefix = 'XtraDB-Cluster-client'
    }
    'server_client': {
      $package_prefix = 'Server-client'
    }
    default: {
      fail('Wrong package!!! Wou must choose one of the follow packages: cluster, server, cluster_client, cluster_server.')
    }
  }

  include percona::preinstall
  include percona::install
  include percona::config
  include percona::service
  include percona::root_password

  anchor{'percona::start': } ->
  Class['percona::preinstall'] ->
  Class['percona::install'] ->
  Class['percona::config'] ->
  Class['percona::service'] ->
  Class['percona::root_password'] ->
  anchor{'percona::end': }

}

