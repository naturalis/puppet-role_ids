# == Class role_ids::params
#
# This class is meant to be called from role_ids.
# It sets variables according to platform.
#
class role_ids::params {
  case $::osfamily {
    'Debian': {
      $package_name = 'role_ids'
      $service_name = 'role_ids'
    }
    'RedHat', 'Amazon': {
      $package_name = 'role_ids'
      $service_name = 'role_ids'
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
