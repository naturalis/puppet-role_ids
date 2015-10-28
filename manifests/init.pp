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
  $scirius_ruleset_url='https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz',
){
  class { '::suricata':
    monitor_interface => $monitor_interface,
  } ->
  class { '::scirius':
    scirius_ruleset_url => $scirius_ruleset_url,
  } ->

  logrotate::rule { 'suricata':
    path          => '/var/log/suricata/*.log /var/log/suricata/*.json',
    rotate        => 3,
    rotate_every  => 'day',
    missingok     => true,
    compress      => false,
    create        => true,
    sharedscripts => true,
    postrotate    => '/usr/bin/kill -HUP $(cat /var/run/suricata.pid)',
  }
}
