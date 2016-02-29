class percona::sst_auth {

  $wsrep_sst_method   = $percona::wsrep_sst_method
  $wsrep_sst_user     = $percona::wsrep_sst_user
  $wsrep_sst_password = $percona::wsrep_sst_password


  if $percona::wsrep_sst_method == 'xtrabackup-v2' {
    percona_user { "${wsrep_sst_user}@localhost":
      ensure        => present,
      password_hash => mysql_password($wsrep_sst_password),
      mgmt_cnf      => $percona::mgmt_cnf,
      require       => File[$percona::mgmt_cnf],
    }
    percona_grant {"${wsrep_sst_user}@localhost":
      mgmt_cnf      => $percona::mgmt_cnf,
      privileges    => ['reload_priv', 'lock_tables_priv', 'repl_client_priv' ],
      require       => Percona_User["${wsrep_sst_user}@localhost"],
    }
  }
}
