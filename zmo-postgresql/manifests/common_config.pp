# Postgresql common_conf class definition

class postgresql::common_config inherits postgresql {

    case $::operatingsystem {
        debian, ubuntu: {
            $postgresql_user      = "postgres"
            $postgresql_user_home = "/var/lib/postgresql"
            $postgresql_packages  = ["postgresql-${psql_version}",
                                    "postgresql-client-${psql_version}",
                                    "postgresql-client-common"]
        }
    }
    
    # Packages installation
    package { $postgresql_packages :
        ensure  => installed,
    }

    # Postgresql user
    user { $postgresql_user :
        ensure => present,
        home   => $postgresql_user_home,
        shell  => "/bin/bash",
        require => Package[$postgresql_packages],
    }
    
    # Create a directory tree
    file { [ "/etc/postgresql/${psql_version}",
           "/etc/postgresql/${psql_version}/main" ]:
        ensure => directory,
        owner  => $postgresql_user,
        group  => $postgresql_user,
        mode   => 0755
    }
    
    # zmo: TEMPORARY -
    file { "/etc/postgresql/${psql_version}/main/pg_hba.conf":
        ensure => directory,
        owner  => $postgresql_user,
        group  => $postgresql_user,
        mode   => 0644,
        source => "puppet:///modules/postgresql/pg_hba.conf"
    }
}
