# Class: percona::install
#
#
class percona::install {
  $package_prefix   = $::percona::package_prefix
  $package_version  = $::percona::package_version

  $pkg_version = regsubst($package_version, '\.', '', 'G')

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $pkg_install = "percona-${package_prefix}-${pkg_version}"
    }
    /(?i:redhat|centos)/: {
      $pkg_install = "percona-${package_prefix}-${pkg_version}"
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }

  Package {
    require => [
      Class['percona::preinstall']
    ],
  }

  package { $pkg_install:
     ensure  => 'installed',
  }

}

