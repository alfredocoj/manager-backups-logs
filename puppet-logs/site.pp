node "192.168.6.95" { # puppetserver

  cron { 'update-manifest':
    command => '/opt/puppetlabs/puppet/bin/r10k deploy environment -pv',
    user    => 'root',
    hour    => '*',
    minute  => '*/1'
  }

  cron { 'run-puppet':
    command =>
      '/opt/puppetlabs/puppet/bin/puppet agent --onetime --no-daemonize --no-usecacheonfailure --detailed-exitcodes -v >> /tmp/mylogs.txt'
    ,
    user    => 'root',
    hour    => '*',
    minute  => '*/5'
  }

  cron { 'shrink':
    name        => 'shrink',
    command     => '/k8s-admin/scripts/shrink.sh',
    hour        => '0',
    minute      => '40',
    user        => 'root',
    weekday     => '7'
  }

  include logrotate
  logrotate::rule { 'messages':
    path         => '/var/log/messages',
    rotate       => 5,
    rotate_every => 'week',
    postrotate   => '/usr/bin/killall -HUP syslogd',
  }

  logrotate::rule { 'docker-logs':
    path          => '/var/lib/docker/containers/*/*.log',
    rotate        => 5,
    rotate_every  => 'week',
    size          => '1M',
    missingok     => true,
    delaycompress => true,
    postrotate    => 'truncate -s 0 /var/lib/docker/containers/*/*-json.log*gz',
  }
}

node "192.168.6.96" { # puppetserver

  cron { 'run-puppet':
    command =>
      '/opt/puppetlabs/puppet/bin/puppet agent --onetime --no-daemonize --no-usecacheonfailure --detailed-exitcodes -v >> /tmp/mylogs.txt'
    ,
    user    => 'root',
    hour    => '*',
    minute  => '*/5'
  }

  cron { 'shrink':
    name        => 'shrink',
    command     => '/k8s-admin/scripts/shrink.sh',
    hour        => '0',
    minute      => '40',
    user        => 'root',
    weekday     => '7'
  }

  include logrotate
  logrotate::rule { 'messages':
    path         => '/var/log/messages',
    rotate       => 5,
    rotate_every => 'week',
    postrotate   => '/usr/bin/killall -HUP syslogd',
  }

  logrotate::rule { 'docker-logs':
    path          => '/var/lib/docker/containers/*/*.log',
    rotate        => 5,
    rotate_every  => 'week',
    size          => '1M',
    missingok     => true,
    delaycompress => true,
    postrotate    => 'truncate -s 0 /var/lib/docker/containers/*/*-json.log*gz',
  }
}

node "192.168.6.97" { # puppetserver

  cron { 'run-puppet':
    command =>
      '/opt/puppetlabs/puppet/bin/puppet agent --onetime --no-daemonize --no-usecacheonfailure --detailed-exitcodes -v >> /tmp/mylogs.txt'
    ,
    user    => 'root',
    hour    => '*',
    minute  => '*/5'
  }

  cron { 'shrink':
    name        => 'shrink',
    command     => '/k8s-admin/scripts/shrink.sh',
    hour        => '0',
    minute      => '40',
    user        => 'root',
    weekday     => '7'
  }

  include logrotate
  logrotate::rule { 'messages':
    path         => '/var/log/messages',
    rotate       => 5,
    rotate_every => 'week',
    postrotate   => '/usr/bin/killall -HUP syslogd',
  }

  logrotate::rule { 'docker-logs':
    path          => '/var/lib/docker/containers/*/*.log',
    rotate        => 5,
    rotate_every  => 'week',
    size          => '1M',
    missingok     => true,
    delaycompress => true,
    postrotate    => 'truncate -s 0 /var/lib/docker/containers/*/*-json.log*gz',
  }
}