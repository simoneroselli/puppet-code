# Php-fpm Purge class
#
# Arrest the php-fpm service, purge php-fpm packages and delete the
# php-fpm config file. Leave the pool.d directory as it is and not
# interfer with the pools configuration

class php-fpm::purge inherits php-fpm::params {
    
    if $fpm_initd == 0 {
        service { $fpm_service :
            ensure => stopped,
        }
    }

    file { $fpm_conf_file :
        ensure => absent,
    }
            
    package { $fpm_packages :
    ensure => purged,
    }
}
