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
  $package_version   = '5.5',
  $manage_repo       = true,
  $package           = 'cluster',

  $config_dir_mode   = '0750',
  $config_file_mode  = '0640',
  $config_user       = 'root',
  $config_group      = 'root',

  $config_content    = undef,

  $config_template   = undef,
  $config_skip       = false,
  $config_replace    = true,
  $config_include_dir = undef,
  $config_file       = undef,

  $service_enable    = true,
  $service_ensure    = 'running',
  $service_name      = 'mysql',
  $service_restart   = true,
  $daemon_group      = 'mysql',
  $daemon_user       = 'mysql',
  $pidfile           = '/var/run/mysqld/mysqld.pid',

  $tmpdir            = undef,
  $logdir            = '/var/log/percona',
  $logdir_group      = 'root',
  $socket            = '/var/lib/mysql/mysql.sock',
  $datadir           = '/var/lib/mysql',
  $targetdir         = '/data/backups/mysql/',
  $error_log         = '/var/log/mysqld.log',


  $pkg_client        = undef,
  $pkg_server        = undef,
  $pkg_common        = undef,
  $pkg_compat        = undef,
  $pkg_version       = undef,

  $mgmt_cnf          = undef,

){

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $config_dir  = '/etc/mysql'
      $default_config_file = '/etc/mysql/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.Debian.erb',
        default => $config_template,
      }
      $config_include_dir_default = "${config_dir}/conf.d"
    }

    /(?i:redhat|centos)/: {
      $default_config_file = '/etc/my.cnf'
      $template    = $config_template ? {
        undef   => 'percona/my.cnf.erb',
        default => $config_template,
      }
      $config_include_dir_default = undef
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }

  $default_config  = {
    'client'          => {
      'port'          => '3306',
      'socket'        => $percona::params::socket,
    },
    'mysqld_safe'        => {
      'nice'             => '0',
      'log-error'        => $percona::params::log_error,
      'socket'           => $percona::params::socket,
    },
    'mysqld'                  => {
      'basedir'               => $percona::params::basedir,
      'bind-address'          => $::fqdn,
      'datadir'               => $percona::params::datadir,
      'expire_logs_days'      => '10',
      'key_buffer_size'       => '16M',
      'log-error'             => $percona::params::log_error,
      'max_allowed_packet'    => '16M',
      'max_binlog_size'       => '100M',
      'max_connections'       => '151',
      'myisam_recover'        => 'BACKUP',
      'pid-file'              => $percona::params::pidfile,
      'port'                  => '3306',
      'query_cache_limit'     => '1M',
      'query_cache_size'      => '16M',
      'skip-external-locking' => true,
      'socket'                => $percona::params::socket,
      'ssl-disable'           => false,
      'thread_cache_size'     => '8',
      'thread_stack'          => '256K',
      'tmpdir'                => $percona::params::tmpdir,
      'user'                  => 'mysql',
    },
    'mysqldump'             => {
      'max_allowed_packet'  => '16M',
      'quick'               => true,
      'quote-names'         => true,
    },
    'isamchk'      => {
      'key_buffer_size' => '16M',
    },
  }

  $_config_file = $config_file ? {
    undef   => $default_config_file,
    default => $config_file,
  }

}
