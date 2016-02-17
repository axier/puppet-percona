# == Class: percona::repo::yum
#
class percona::repo::yum {

  yumrepo { 'percona-release-$basearch':
    descr    => 'Percona-Release YUM repository - $basearch',
    baseurl  => 'http://repo.percona.com/release/$releasever/RPMS/$basearch',
    gpgkey   => 'http://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona',
    enabled  => 1,
    gpgcheck => 1,
  }
  yumrepo { 'percona-release-noarch':
    descr    => 'Percona-Release YUM repository - noarch',
    baseurl  => 'http://repo.percona.com/release/$releasever/RPMS/noarch',
    gpgkey   => 'http://www.percona.com/downloads/percona-release/RPM-GPG-KEY-percona',
    enabled  => 1,
    gpgcheck => 1,
  }

}
