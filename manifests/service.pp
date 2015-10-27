# == Class role_ids::service
#
# This class is meant to be called from role_ids.
# It ensure the service is running.
#
class role_ids::service {

  service { $::role_ids::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
