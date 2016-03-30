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
  $enable_filebeat=false,
  $logstash_private_key,
  $logstash_certificate,
  $logstash_servers=['piet.logstash.naturalis.nl'],
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
  if ($enable_filebeat) {
    class { '::role_logging::beats':
      logstash_private_key => $logstash_private_key,
      logstash_certificate => $logstash_certificate,
      logstash_servers     => $logstash_servers,
      log_files_to_follow  => [
        {'paths'   => ['/var/log/suricata/eve.json'],
          'fields' => {
            'type' => 'idsevent',
          }
        },
        {'paths'   => ['/var/log/suricata/suricata.log.json'],
          'fields' => {
            'type' => 'idslog',
          }
        }
      ],
    }
  }
}
