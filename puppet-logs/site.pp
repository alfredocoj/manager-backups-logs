node "192.168.6.95" { # puppetmaster

  include 'stdlib'
  include 'sudo'

  user { 'k8s-admin':
    ensure     => present,
    groups     => 'root',
    shell      => '/bin/bash',
    home       => '/home/k8s-admin',
    managehome => true,
    password   => '!coalizao',
  }

  sudo::directive { 'k8s-admin':
    content => "k8s-admin ALL=ALL:ALL \n",
  }

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
    name    => 'shrink',
    command => '/home/k8s-admin/scripts/shrink.sh',
    hour    => '23',
    minute  => '00',
    user    => 'root',
    weekday => '7'
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

node "192.168.6.96" { # puppetagent

  include 'stdlib'
  include 'sudo'

  user { 'k8s-admin':
    ensure     => present,
    groups     => 'root',
    shell      => '/bin/bash',
    home       => '/home/k8s-admin',
    managehome => true,
    password   => '!coalizao',
  }

  sudo::directive { 'k8s-admin':
    content => "k8s-admin ALL=ALL:ALL \n",
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
    name    => 'shrink',
    command => '/home/k8s-admin/scripts/shrink.sh',
    hour    => '23',
    minute  => '00',
    user    => 'root',
    weekday => '7'
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

node "192.168.6.97" { # puppetagent

  include 'stdlib'
  include 'sudo'

  user { 'k8s-admin':
    ensure     => present,
    groups     => 'root',
    shell      => '/bin/bash',
    home       => '/home/k8s-admin',
    managehome => true,
    password   => '!coalizao',
  }

  sudo::directive { 'k8s-admin':
    content => "k8s-admin ALL=ALL:ALL \n",
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
    name    => 'shrink',
    command => '/home/k8s-admin/scripts/shrink.sh',
    hour    => '23',
    minute  => '00',
    user    => 'root',
    weekday => '7'
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