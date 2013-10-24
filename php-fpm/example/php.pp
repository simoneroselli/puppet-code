# Php class declaration

class php {

    # Values: present|absent
    class { 'php-fpm' : 
        ensure => 'present',
    }

    # Pool configuration
    php-fpm::pool { '<pool_name>':

        /* Pool configuration */
        pm                        => 'dynamic',
        pm_max_children           => '64',
        pm_start_servers          => '15',
        pm_min_spare_servers      => '5',
        pm_max_spare_servers      => '60',
        pm_max_requests           => '5000',
        request_terminate_timeout => '120',
        request_slowlog_timeout   => '30s',
        
        /* Global pool settings */
        application_env           => '<environment>',
        diplay_errors             => 'off',
        expose_php                => 'off',

        /* Pool specific settings */
        log_errors                => 'on',
        short_open_tag            => 'on',
        upload_max_filesize       => '8M',
        date_timezone             => 'Europe/Rome',
        post_max_size             => '8M',
        max_execution_time        => '60',
        memory_limit              => '256M',
        max_input_time            => '120',
    }
}
