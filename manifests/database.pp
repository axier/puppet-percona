define percona::database (
  $ensure   = 'present',
  $charset  = 'utf8',
  $mgmt_cnf = undef
) {

  $mycnf = $mgmt_cnf ? {
    undef   => $::percona::mgmt_cnf,
    default => $mgmt_cnf,
  }

  mysql_database { $name:
    ensure   => $ensure,
    charset  => $charset,
    mgmt_cnf => $mycnf,
    require  => Service[$::percona::service_name],
  }

}
