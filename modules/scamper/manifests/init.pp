class scamper {

    package { ['scamper', 'libscamperfile0']:
        ensure      => 'latest',
    }

    file { "/etc/init/scamper.conf":
        source => "puppet:///scamper/upstart-scamper.conf",
    }

    file { "/home/scamper/run-traces.sh":
        source => "puppet:///scamper/run-traces.sh",
        owner => "scamper",
        group => "scamper",
        mode => "0755",
        require => User["scamper"],
    }

    service { "scamper":
        ensure      => 'running',
        provider    => 'upstart',
        require     => [Package['scamper'], File['/etc/init/scamper.conf']],
        subscribe   => File["/etc/init/scamper.conf"],
    }

    file { "/home/scamper/traces/":
        ensure => directory,
        owner => "scamper",
        group => "scamper",
        require => User["scamper"],
    }


    $first = fqdn_rand(60)

    cron { "collect_all_traces":
        user => "scamper",
        command => "/home/scamper/run-traces.sh",
        minute => $first,
        hour => "*",
        require => [Service["scamper"], File["/home/scamper/collected/"], File["/home/scamper/run-traces.sh"]],
    }

    cron { "clean_scamper":
        user => "scamper",
        command => "find /home/scamper/collected/* -mtime +8 -exec rm {} \;",
        minute => "10",
        hour => "00",
        require => FIle["/home/scamper/collected/"],
        ensure => absent,
    }

    @@line { "scamper_target_${fqdn}":
        file    => "/home/scamper/scamper-hosts",
        line    => "${fqdn}",
        tag     => "scamper_collector",
        ensure  => present,
    }

}

class scamper::collector {
    
    Line <<| tag == "scamper_collector" |>>

}
