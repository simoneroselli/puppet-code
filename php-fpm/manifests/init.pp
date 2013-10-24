# Php-fpm class definition
#
# Install/Remove php5-fpm package. Refresh the php-fpm service
# everytime a change has occured in the configuration file

class php-fpm(
    
    $ensure
    
    ) inherits php-fpm::params { 

    case $ensure {
        'absent': {
            include php-fpm::purge
        }
        'present': {
            package { $fpm_packages :
                ensure => installed,
            }

            file { $fpm_conf_file :
                ensure  => present,
                owner   => 'root',
                group   => 'root',
                source  => 'puppet:///modules/php-fpm/php-fpm.conf',
                require => Package[$fpm_packages],
            }

            file { $fpm_pool_dir :
                ensure => directory,
            }
            
            service { $fpm_service :
                ensure => running,
                hasrestart => true,
                hasstatus  => true,
                subscribe => File[$fpm_pool_dir]
            }
        }
        default: { fail("Allowed parameters <present|absent>") }
    }
}
