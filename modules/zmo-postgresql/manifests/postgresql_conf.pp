# Postgresql Conf class definition

class postgresql::postgresql_conf(
    
    /* Postgresql.conf values */
    $data_directory                  = undef,
    $hba_file                        = undef,
    $ident_file                      = undef,
    $external_pid_file               = undef,

    $listen_addresses                = undef,
    $max_connections                 = undef,
    $unix_socket_permissions         = undef,
    $shared_buffers                  = undef,
    $work_mem                        = undef,
    $maintenance_work_mem            = undef,
    $hot_standby                     = undef,
    $wal_level                       = undef,
    $wal_buffers                     = undef,
    $archive_mode                    = undef,
    $archive_command                 = undef,
    $max_wal_senders                 = undef,
    $wal_keep_segments               = undef,
    $logging_collector               = undef,
    $log_directory                   = undef,
    $log_filename                    = undef,
    $log_min_duration_statement      = undef,
    $track_functions                 = undef,
    $track_activities                = undef,
    $track_counts                    = undef,
    $stats_temp_directory            = undef,
    $log_planner_stats               = undef,
    $log_executor_stats              = undef,
    $log_statement_stats             = undef,
    $autovacuum                      = undef,
    $log_autovacuum_min_duration     = undef,
    $autovacuum_max_workers          = undef,
    $autovacuum_naptime              = undef,
    $autovacuum_vacuum_threshold     = undef,
    $autovacuum_analyze_threshold    = undef,
    $autovacuum_vacuum_scale_factor  = undef,
    $autovacuum_analyze_scale_factor = undef,
    $autovacuum_freeze_max_age       = undef,
    $autovacuum_vacuum_cost_delay    = undef,
    $autovacuum_vacuum_cost_limit    = undef,
    
    ) inherits postgresql {
    
    file { $postgresql_conf :
        ensure  => present,
        owner   => "postgres",
        group   => "postgres",
        mode    => 0644,
        content => template("postgresql/${postgresql_conf_templ}"),
        notify  => Service[ $postgresql_service ],
    }

    # Custom environment
    # Setup the custom datadir
    if $data_directory != undef and $data_directory != $postgresql_default_dir {
        class { 'postgresql::custom_env': }
    }

    # TODO: check for resource order before this check
    #file { $data_directory :
    #    ensure => directory,
    #    owner  => "postgres",
    #    group  => "postgres",
    #    mode   => 0700,
    #}

}

