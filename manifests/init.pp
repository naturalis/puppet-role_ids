# == Class: role_ids
#
# Full description of class role_ids here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class role_ids(
  $monitor_interface=eth1,
){
  class { '::suricata':
    monitor_interface => $monitor_interface,
  }
  include ::scirius
}
