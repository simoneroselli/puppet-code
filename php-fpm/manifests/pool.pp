# Php-fpm pool class
#
# Configure the pool in /etc/php5-fpm/pool.d directory. Refresh the
# php5-fpm service everytime a file*.conf in the pool.d directory has changed

define php-fpm::pool(
    
    /* Pool Config */
    $pm                        = undef,
    $pm_max_children           = undef,
    $pm_start_servers          = undef,
    $pm_min_spare_servers      = undef,
    $pm_max_spare_servers      = undef,
    $pm_max_requests           = undef,
    $request_terminate_timeout = undef,
    $request_slowlog_timeout   = undef,
    
    $application_env           = undef,
    $diplay_errors             = undef,
    $expose_php                = undef,

    $log_errors                = undef,
    $short_open_tag            = undef,
    $upload_max_filesize       = undef,
    $date_timezone             = undef,
    $post_max_size             = undef,
    $max_execution_time        = undef,
    $memory_limit              = undef,
    $max_input_time            = undef,
    
    ) {

    case $operatingsystem {
        debian,ubuntu: {
            $fpm_template     = "php-fpm/pool_template.conf.erb"
            $fpm_pool_dir     = "/etc/php5/fpm/pool.d"
            $fpm_pool_log_dir = "/var/log/php-fpm"
            $fpm_pool_log     = "${fpm_pool_log_dir}/${name}.slow.log"
            $fpm_service      = "php5-fpm"
        }
    }

    file { "${fpm_pool_dir}/${name}.conf":
        content => template($fpm_template),
        owner   => 'root',
        group   => 'root',
        mode    => '644',
        notify  => Service[$fpm_service],
    }
    
    file { $fpm_pool_log_dir :
        ensure => directory,
        owner  => 'root',
        group  => 'adm',
        mode   => '644',
    }

    file { $fpm_pool_log :
        ensure  => present,
        owner   => 'root',
        group   => 'adm',
        mode    => '644',
        require => File[$fpm_pool_log_dir],
    }
}
