# nodes.pp
#
## Hosts

node basenode {
    include cronjobs
    include groups
    include nettools
    include etcfiles
    include local_binaries
    include munin::client
    munin::plugin { ["users", "tcp", "ntp_offset"]:
    }
    include nlnogrepokey
    include ssh
    include timezone
    include fail2ban-whitelist
    $postfix_smtp_listen = "127.0.0.1"
    $root_mail_recipient = "ring-admins@ring.nlnog.net"
    $postfix_myorigin = ""
    include postfix
}

node ringnode inherits basenode {
    include ring_users
    include ring_admins
    include no-apache2
    include syslog_ng::client
    include nodesonlycron
    include uva
    package{ "munin": ensure => purged, }
}

node 'master01' inherits basenode {
    include ring_admins
    include munin::host
    include master_software
    include syslog_ng::server
    include apache2
    include mastercronjobs
    include nagios::defaults
    include nagios::headless
    include nagios_services
    nagios::service::http { $name:
        check_domain => "${name}"
    }
    include nagios::target
    munin::plugin { ["apache_accesses", "apache_processes", "apache_volume"]:
    }

}

node 'master02' inherits basenode {
    include ring_admins
# this is not a puppetmaster for now
#    include master_software
#    include mastercronjobs
    include syslog_ng::server
    include apache2

    $sp_owner = "Job Snijders"
    $sp_owner_email = "job@snijders-it.nl"
    $sp_cgi_url = "http://master02.ring.nlnog.net/smokeping/smokeping.fcgi"
    $sp_mailhost = "127.0.0.1"
    include smokeping::master

    include nagios_services
    include nagios::target
    
    nagios::service::http { $name:
        check_domain => "${name}"
    }
    
    munin::plugin { ["apache_accesses", "apache_processes", "apache_volume"]:
    }

}

# we don't want apache running on regular ringnodes. smokeping installs 
# apache, so we just force it down here. 
class apache2 {
    service { "apache2":
        alias => "apache",
        enable => true,
        ensure => running,
    }
}

class no-apache2 {
    service { "apache2":
        enable => false,
        ensure => stopped,
        require => Package["apache2"],
    }
}

# add things that should be checked here
class nagios_services {
    nagios::service::ping { $name: }
    nagios::service::ssh { $name: }
}

## define all groups

class groups {
    add_group { ring-users:
        gid => 5000
    }
    add_group { admin:
        gid => 99
    }
    add_group { ring-admins:
        gid => 6000 
    }
}

#### staging #####

node 'staging01' inherits ringnode {
    $owner = "job"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'staging02' inherits ringnode {
    $owner = "job"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

#### einde staging #####

#### define all ring nodes ####

node 'intouch01' inherits ringnode {
    $owner = "intouch"
    $location = "52.355930,4.951873"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'bit01' inherits ringnode {
    $owner = "bit"
    $location = "52.027596,5.624528"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'coloclue01' inherits ringnode {
    $owner = "coloclue"
    $location = "52.332901,4.919525"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'widexs01' inherits ringnode {
    $owner = "widexs"
    $location = "52.399982,4.842305"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'xlshosting01' inherits ringnode {
    $owner = "xlshosting"
    $location = "52.332912,4.919461"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'interconnect01' inherits ringnode {
    $owner = "interconnect"
    $location = "51.686672,5.359043"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'cambrium01' inherits ringnode {
    $owner = "cambrium"
    $location = "52.340988,5.227518"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'cyso01' inherits ringnode {
    $owner = "cyso"
    $location = "52.343983,4.828710"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'zylon01' inherits ringnode {
    $owner = "zylon"
    $location = "52.396420,4.851092"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'duocast01' inherits ringnode {
    $owner = "duocast"
    $location = "53.246086,6.528518"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'easyhosting01' inherits ringnode {
    $owner = "easyhosting"
    $location = "52.391132,4.665263"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'previder01' inherits ringnode {
    $owner = "previder"
    $location = "52.243954,6.767229"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'leaseweb01' inherits ringnode {
    $owner = "leaseweb"
    $location = "52.391224,4.665155"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'nxs01' inherits ringnode {
    $owner = "nxs"
    $location = "52.393200,4.847546"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'ic-hosting01' inherits ringnode {
    $owner = "ic-hosting"
    $location = "52.282215,4.772927"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'xs4all01' inherits ringnode {
    $owner = "xs4all"
    $location = "52.336353,4.886652"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'nedzone01' inherits ringnode {
    $owner = "nedzone"
    $location = "51.587601,4.305047"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'oxilion01' inherits ringnode {
    $owner = "oxilion"
    $location = "52.243969,6.767278"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'ebayclassifiedsgroup01' inherits ringnode {
    $owner = "ebayclassifiedsgroup"
    $location = "52.280964,4.754237"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'is01' inherits ringnode {
    $owner = "is"
    $location = "52.396759,4.838742"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'surfnet01' inherits ringnode {
    $owner = "surfnet"
    $location = "52.090767,5.112371"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'prolocation01' inherits ringnode {
    $owner = "prolocation"
    $location = "52.343983,4.828710"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'in2ip01' inherits ringnode {
    $owner = "in2ip"
    $location = "52.395855,4.841133"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'netground01' inherits ringnode {
    $owner = "netground"
    $location = "52.343983,4.828710"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'totaalnet01' inherits ringnode {
    $owner = "totaalnet"
    $location = "51.987831,5.933394"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'signet01' inherits ringnode {
    $owner = "signet"
    $location = "51.501537,5.460406"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tripleit01' inherits ringnode {
    $owner = "tripleit"
    $location = "52.303066,4.937898"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'jaguarnetwork01' inherits ringnode {
    $owner = "jaguarnetwork"
    $location = "43.310226,5.373356"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tuxis01' inherits ringnode {
    $owner = "tuxis"
    $location = "52.027649,5.624506"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tenet01' inherits ringnode {
    $owner = "tenet"
    $location = "-26.204103,28.047304"
    $nagios_ping_rate = '!300.0,20%!500.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'bigwells01' inherits ringnode {
    $owner = "bigwells"
    $location = "41.892365,-87.634918"
    $nagios_ping_rate = '!250.0,20%!500.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'atrato01' inherits ringnode {
    $owner = "atrato"
    $location = "50.059772,14.480634"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tdc01' inherits ringnode {
    $owner = "tdc"
    $location = "60.221024,24.848589"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'netability01' inherits ringnode {
    $owner = "netability"
    $location = "53.405754,-6.372293"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'unilogicnetworks01' inherits ringnode {
    $owner = "unilogicnetworks"
    $location = "50.996090,5.845644"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'maverick01' inherits ringnode {
    $owner = "maverick"
    $location = "52.393036,16.947895"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'acsystemy01' inherits ringnode {
    $owner = "acsystemy"
    $location = "53.910034,14.247578"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'netsign01' inherits ringnode {
    $owner = "netsign"
    $location = "52.465530,13.368666"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'rrbone01' inherits ringnode {
    $owner = "rrbone"
    $location = "51.188271,6.867769"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'hosteam01' inherits ringnode {
    $owner = "hosteam"
    $location = "52.227661,21.004250"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'msp01' inherits ringnode {
    $owner = "msp"
    $location = "51.525089,-0.072224"
    include smokeping::slave
    munin::plugin { ["sensors_volt", "sensors_temp", "sensors_fan"]:
        ensure => "sensors_" 
    }
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'inotel01' inherits ringnode {
    $owner = "inotel"
    $location = "52.391102,16.897284"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'fremaks01' inherits ringnode {
    $owner = "fremaks"
    $location = "53.077320,8.772950"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'blix01' inherits ringnode {
    $owner = "blix"
    $location = "59.924725,10.810183"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'portlane01' inherits ringnode {
    $owner = "portlane"
    $location = "59.306946,18.130274"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'solido01' inherits ringnode {
    $owner = "solido"
    $location = "55.728542,12.376454"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'digmia01' inherits ringnode {
    $owner = "digmia"
    $location = "48.119209,17.095844"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'rootlu01' inherits ringnode {
    $owner = "rootlu"
    $location = "49.671227,6.125205"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'globalaxs01' inherits ringnode {
    $owner = "globalaxs"
    $location = "53.461365,-2.324666"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'nebula01' inherits ringnode {
    $owner = "nebula"
    $location = "60.218018,24.879240"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tilaa01' inherits ringnode {
    $owner = "tilaa"
    $location = "52.391090,4.665314"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'nautile01' inherits ringnode {
    $owner = "nautile"
    $location = "-22.267935,166.462219"
    $nagios_ping_rate = '!450.0,20%!700.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'voxel01' inherits ringnode {
    $owner = "voxel"
    $location = "37.241619,-121.783218"
    $nagios_ping_rate = '!250.0,20%!500.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'voxel02' inherits ringnode {
    $owner = "voxel"
    $location = "1.295461,103.789787"
    $nagios_ping_rate = '!550.0,20%!900.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'neotelecoms01' inherits ringnode {
    $owner = "neotelecoms"
    $location = "48.899693,2.296256"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'apnic01' inherits ringnode {
    $owner = "apnic"
    $location = "-27.458248,153.031067"
    $nagios_ping_rate = '!500.0,20%!800.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'atrato02' inherits ringnode {
    $owner = "atrato"
    $location = "40.717884,-74.008938"
    $nagios_ping_rate = '!200.0,20%!400.0,60%'
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'man-da01' inherits ringnode {
    $owner = "man-da"
    $location = "49.86170,8.68210"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'webair01' inherits ringnode {
    $owner = "webair"
    $location = "40.722529,-73.632961"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'concepts-ict01' inherits ringnode {
    $owner = "concepts-ict"
    $location = "51.592992,4.802703"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'dataoppdrag01' inherits ringnode {
    $owner = "dataoppdrag"
    $location = "60.295349,5.255753"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'tetaneutral01' inherits ringnode {
    $owner = "tetaneutral"
    $location = "43.61847,1.42075"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'jump01' inherits ringnode {
    $owner = "jump01"
    $location = "51.5120776,-0.0020345"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'iway01' inherits ringnode {
    $owner = "iway"
    $location = "47.387639, 8.519944"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'timico01' inherits ringnode {
    $owner = "timico"
    $location = "53.07897,-0.792212"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'yacast01' inherits ringnode {
    $owner = "yacast"
    $location = "48.90541,2.369790"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'rezopole01' inherits ringnode {
    $owner = "rezopole"
    $location = "45.72289,4.861422"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'globalaxs02' inherits ringnode {
    $owner = "globalaxs"
    $location = "51.511526923,-0.0011855363845825195"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'solnet01' inherits ringnode {
    $owner = "solnet"
    $location = "47.20182,7.52878"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'boxed-it01' inherits ringnode {
    $owner = "boxed-it"
    $location = "50.881431,4.454129"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'spacenet01' inherits ringnode {
    $owner = "spacenet"
    $location = "48.133333,11.566667"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'mironet01' inherits ringnode {
    $owner = "mironet"
    $location = "47.5143,7.616726"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'seeweb01' inherits ringnode {
    $owner = "seeweb"
    $location = "45.478696,9.105091"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'networkdesign01' inherits ringnode {
    $owner = "networkdesign"
    $location = "47.38339,8.49560"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}

node 'zensystems01' inherits ringnode {
    $owner = "zensystems"
    $location = "55.7284634,12.376985"
    include smokeping::slave
    include nagios::target
    include nagios_services
    include set_local_settings
}
