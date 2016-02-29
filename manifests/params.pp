# == Class percona::params
#
# The params class can be used to default configuration that
# transcendents specific node configuration. This can be used
# to set global defaults outside the node {} (or included classes)
# declaration. Everything in the params class can be overridden
# in the parameters of the percona class.
#
# === Parameters:
#
# $config_include_dir::     Folder to include using '!includedir' in the mysql
#                           configuration folder. Defaults to /etc/mysql/conf.d
#                           for debian. If overridden, we will attempt to
#                           create it but the parent directory should exist.
#
# $mgmt_cnf::               Path to the my.cnf file to use for authentication.
#
# $manage_repo::            This module can optionally install apt/yum repos.
#                           Disabled by default.
#
# $service_restart::        Should we restart the server after changing the
#                           configs? On some systems, this may be a bad thing.
#                           Ex: Wait for a maintenance weekend.
#
# $default_configuration::  A hash table containing specific options to set for
#                           a percona version. It should be a hashtable with
#                           for each percona version a sub-entry.
#
#
# === Provided parameters:
#
# $template::               Either the configured ($config_)template. Or our
#                           default template which is OS specific.
#
# $config_dir::             Location of the folder which holds the mysql my.cnf
#                           file for your operatingsystem.
#
# $config_file::            Location of the default mysql my.cnf config file
#                           for your operatingsystem.
#
# === Examples:
#
# ==== Setting global and default configuration options.
#
# === Todo:
#
# TODO: Document parameters
#
class percona::params (
  $package_version                = '5.6',
  $manage_repo                    = true,
  $mode                           = 'cluster',
  $master                         = false,

  $config_file_mode               = '0644',
  $config_include_dir             = undef,
  $config_include_dir_mode        = '0744',
  $config_user                    = 'root',
  $config_group                   = 'root',
  $manage_config_file             = true,

  $service_enable                 = true,
  $service_ensure                 = 'running',
  $service_name                   = 'mysql',
  $service_restart                = true,
  $daemon_group                   = 'mysql',
  $daemon_user                    = 'mysql',
  $pidfile                        = '/var/run/mysqld/mysqld.pid',
  $basedir                        = '/usr',
  $bind_address                   = $::fqdn,
  $port                           = '3306',
  $max_connections                = '512',
  $mysql_user                     = 'mysql',

  $tmpdir                         = '/tmp',
  $logdir                         = '/var/log/percona',
  $logdir_group                   = 'root',
  $socket                         = '/var/lib/mysql/mysql.sock',
  $datadir                        = '/var/lib/mysql',
  $targetdir                      = '/data/backups/mysql/',
  $error_log                      = '/var/log/mysqld.log',

  $default_storage_engine         = 'InnoDB',
  $binlog_format                  = 'ROW',
  $wsrep_provider                 = '/usr/lib64/libgalera_smm.so',
  $wsrep_cluster_name             = 'custerPercona',
  $wsrep_sst_method               = 'rsync',
  $wsrep_slave_threads            = 8,

  $innodb_buffer_pool_size        = '1G',
  $innodb_log_file_size           = '2047M',
  $innodb_log_buffer_size         = '128M',
  $innodb_file_per_table          = 1,
  $innodb_autoinc_lock_mode       = 2,
  $innodb_flush_log_at_trx_commit = 0,
  $innodb_support_xa              = 0,
  $innodb_doublewrite             = 0,
  $innodb_flush_method            = O_DIRECT,

  $query_cache_size               = 0,
  $query_cache_type               = 0,

  $symbolic_links                 = 0,
  $sync_binlog                    = 0,
  $log_bin                        = '/var/lib/mysql/binlog',

  $mgmt_cnf                       = '/etc/.my.cnf',



){

  case $::operatingsystem {
    /(?i:redhat|centos)/: {
      $config_dir                 = '/etc'
      $default_config_file        = "${config_dir}/my.cnf"
      $config_include_dir_default = "${config_dir}/my.cnf.d"
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }
}
