# == Class role_ids::install
#
# This class is called from role_ids for install.
#
class role_ids::install {

  package { $::role_ids::package_name:
    ensure => present,
  }
}
