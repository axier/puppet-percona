# Class: percona::config
#
#
class percona::config {

  $mode = $::percona::mode

  case $mode {
    'cluster': {
      include percona::config::cluster
    }
    'server': {
      include percona::config::server
    }
    'cluster_client': {
      include percona::config::cluster_client
    }
    'server_client': {
      include percona::config::server_client
    }
    default: {
        fail('Wrong mode!!! Wou must choose one of the follow packages: cluster, server, cluster_client, cluster_server.')
    }
  }
}
