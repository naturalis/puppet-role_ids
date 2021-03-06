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
  $monitor_interface=em2,
  $scirius_ruleset_url='https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz',
  $scirius_admin='admin',
  $scirius_admin_pass='changeme',
  $enable_filebeat=false,
  $logstash_private_key_file='/etc/ssl/logstash_key.key',
  $logstash_certificate_file='/etc/ssl/logstash_cert.crt',
  $logstash_private_key=file($logstash_private_key_file),
  $logstash_certificate=file($logstash_certificate_file),
  $logstash_servers=['piet.logstash.naturalis.nl'],
){
  # validate parameters
  validate_string($monitor_interface)
  validate_string($scirius_ruleset_url)
  validate_string($scirius_admin)
  validate_string($scirius_admin_pass)
  validate_bool($enable_filebeat)
  validate_absolute_path($logstash_private_key_file)
  validate_absolute_path($logstash_certificate_file)
  validate_string($logstash_private_key)
  validate_string($logstash_certificate)
  validate_array($logstash_servers)


  class { '::suricata':
    monitor_interface => $monitor_interface,
  } ->
  class { '::scirius':
    scirius_ruleset_url => $scirius_ruleset_url,
    scirius_admin       => $scirius_admin,
    scirius_admin_pass  => $scirius_admin_pass,
  } ->

  logrotate::rule { 'suricata':
    path          => '/var/log/suricata/*.log /var/log/suricata/*.json',
    rotate        => 3,
    rotate_every  => 'day',
    missingok     => true,
    compress      => false,
    create        => true,
    sharedscripts => true,
    postrotate    => '/bin/kill -HUP $(cat /var/run/suricata.pid)',
  }

  # create suricataboot.sh
  file{ 'suricataboot':
    path    => '/usr/local/bin/suricataboot.sh',
    content => template('role_ids/suricataboot.sh.erb'),
    mode    => '0544',
  }
  # run puppet at startup to configure and run suricata
  cron { 'suricataboot_cron':
    command => '/usr/local/bin/suricataboot.sh',
    user    => root,
    special => reboot,
  }

  if ($enable_filebeat) {
    class { '::role_logging::beats':
      logstash_private_key => $logstash_private_key,
      logstash_certificate => $logstash_certificate,
      logstash_servers     => $logstash_servers,
      log_files_to_follow  => [
        {'paths'   => ['/var/log/suricata/eve.json'],
          'fields' => {
            'type'             => 'idsevent',
            'geoip_src_field'  => 'source_ip_field',
            'geoip_dest_field' => 'destination_ip_field',
            'testdata'         => 'true',
          }
        },
        {'paths'   => ['/var/log/suricata/suricata.log.json'],
          'fields' => {
            'type'     => 'idslog',
            'testdata' => 'true',
          }
        }
      ],
    }
  }
}
