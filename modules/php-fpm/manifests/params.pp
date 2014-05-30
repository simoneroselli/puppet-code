# Php-fpm Params class
#
# Params inherited from other php-fpm modules

class php-fpm::params {

    case $operatingsystem {
        debian, ubuntu: {
            $fpm_conf_dir  = "/etc/php5/fpm"
            $fpm_pool_dir  = "/etc/php5/fpm/pool.d"
            $fpm_conf_file = "/etc/php5/fpm/php-fpm.conf"
            $fpm_packages  = "php5-fpm"
            $fpm_service   = "php5-fpm"
            $fpm_initd     = "test -a /etc/init.d/php5-fpm"
        }
        default: { fail("Uknown Operating System") }
    }
}
