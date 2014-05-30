# == Class: postgresql
#
# The module allows to setup a <master/standby> role postgresql DB.
#
# === Authors
#
# ZMo <simoneroselli78@gmail.com>
#
#
class postgresql {

    $psql_version,
    
    ) {
    
    case $::operatingsystem {
        debian, ubuntu : {
            $postgresql_service = "postgresql"
            $postgreqsl_datadir  = "/etc/postgresql/${psql_version}/main"
            $postgresql_conf       = "/etc/postgresql/${psql_version}/main/postgresql.conf"
            $postgresql_conf_templ = "postgresql.conf.deb.erb"
            $postgresql_default_dir = "/var/lib/postgresql/${psql_version}/main"
        }
    }

    class { 'postgresql::repository':
        before => Class['postgresql::common_config'], 
    }

    include postgresql::common_config

        
    service { $postgresql_service :
        ensure    => running,
        enable    => true,
        hasstatus => true,
    }
}
