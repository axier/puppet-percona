class percona::root_password {

  $user     = 'root'
  $password = $percona::root_password
  $host     = 'localhost'



  if $percona::root_password != 'UNSET' {
    if !percona_check_file($percona::mgmt_cnf) and $percona::master {
      exec {'percona-root-password':
        onlyif    => [
          'test -f /usr/bin/mysqladmin',
          "mysqladmin --no-defaults -u${user} -h${host} status",
        ],
        unless    => "test -f $percona::mgmt_cnf",
        path      => ['/usr/bin','/bin',],
        command   => "mysqladmin -h ${host} -u${user} password ${password}",
        before    => File[$percona::mgmt_cnf],
      }

    } else {
      percona_user { "${user}@${host}":
        ensure        => present,
        password_hash => mysql_password($percona::root_password),
        mgmt_cnf      => $percona::mgmt_cnf,
        before        => File[$percona::mgmt_cnf],
      }
    }
    file { $percona::mgmt_cnf:
      owner   => $percona::config_user,
      group   => $percona::config_group,
      mode    => '0600',
      content => template("${module_name}/mgmt_cnf.erb"),
    }
  }
}
