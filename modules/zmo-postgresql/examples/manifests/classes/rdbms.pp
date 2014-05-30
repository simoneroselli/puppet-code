# Database class declaration
#

class rdbms {

    $psql_role_definition = hiera('psql_role_definition')
    $psql_version = hiera('psql_version')
    $psql_shmmax = hiera('psql_shmmax')

    case "${psql_role_definition}" {
        
        /* postgresql.conf: MASTER */ 
        master : {
            $wal_level                       = "hot_standby"
            $wal_buffers                     = "16MB"
            $archive_mode                    = "on"
            $archive_command                 = "cp %p /var/lib/postgresql/${psql_version}/pg_wal/%f"
            $max_wal_senders                 = "10"
            $wal_keep_segments               = "64"
            $hot_standby                     = "on"
            
            /* Runtime statistics */
            $track_activities                = "on"
            $track_counts                    = "on"
            $track_functions                 = "all"
            $log_planner_stats               = "off"
            $log_executor_stats              = "off"
            $log_statement_stats             = "off" 

            /* Autovacuum Parameters */
            $autovacuum                      = "on"
            $log_autovacuum_min_duration     = "-1"
            $autovacuum_max_workers          = "3"
            $autovacuum_naptime              = "1min"
            $autovacuum_vacuum_threshold     = "100"
            $autovacuum_analyze_threshold    = "100"
            $autovacuum_vacuum_scale_factor  = "0.2"
            $autovacuum_analyze_scale_factor = "0.1"
            $autovacuum_freeze_max_age       = "200000000"
            $autovacuum_vacuum_cost_delay    = "20ms"
            $autovacuum_vacuum_cost_limit    = "-1"
            
        }
        
        /* postgresql.conf: STANDBY */ 
        standby : {
            $wal_level                       = "hot_standby"
            $wal_buffers                     = "16MB"
            $max_wal_senders                 = "5"
            $wal_keep_segments               = "64"
            $hot_standby                     = "on"
            $max_standby_archive_delay       = "-1"
            $max_standby_streaming_delay     = "-1"
            $log_planner_stats               = "log_planner_stats = off"
            $log_executor_stats              = "log_executor_stats = off"
            $log_statement_stats             = "log_statement_stats = off" 
        }
    
        default : { 
            fail("${psql_role_definition} is not a valid role! Check your hieradata value.") 
        }
    }

    # Increase the shmmax kernel value for a Postgres "shared_buffer = 1GB".
    # TODO: adjust the kernel value along the given "shared_buffer" value
    sysctl { "kernel.shmmax": value => $psql_shmmax }

    /* Postgresql installation */
    class { 'postgresql':
        psql_version => $psql_version,
    }
 
    class { 'postgresql::postgresql_conf':  
        
        /* Common postgresql values */
        data_directory             => "/data/postgresql/${psql_version}/main",
        hba_file                   => "/etc/postgresql/${psql_version}/main/pg_hba.conf",
        ident_file                 => "/etc/postgresql/${psql_version}/main/pg_ident.conf",
        
        listen_addresses           => "*",
        max_connections            => "100",
        unix_socket_permissions    => "0777",
        shared_buffers             => "32MB",
        work_mem                   => "64MB",
        maintenance_work_mem       => "16MB",
        stats_temp_directory       => "pg_stat_tmp",
        log_directory              => "/var/log/postgresql",
        log_filename               => "postgresql-%Y-%m-%d_%H%M%S.log",
        logging_collector          => "on",
        log_min_duration_statement => "1000",

        /* Roles declaration */
        external_pid_file               => $external_pid_file,
        wal_level                       => $wal_level,
        wal_buffers                     => $wal_buffers,
        archive_mode                    => $archive_mode,
        archive_command                 => $archive_command,
        max_wal_senders                 => $max_wal_senders,
        wal_keep_segments               => $wal_keep_segments,
        hot_standby                     => $hot_standby,
        track_activities                => $track_activities,
        track_counts                    => $track_counts,
        track_functions                 => $track_functions,
        log_planner_stats               => $log_planner_stats,
        log_executor_stats              => $log_executor_stats,
        log_statement_stats             => $log_statement_stats,
        autovacuum                      => $autovacuum,
        log_autovacuum_min_duration     => $log_autovacuum_min_duration,
        autovacuum_max_workers          => $autovacuum_max_workers,
        autovacuum_naptime              => $autovacuum_naptime,
        autovacuum_vacuum_threshold     => $autovacuum_vacuum_threshold,
        autovacuum_analyze_threshold    => $autovacuum_analyze_threshold,
        autovacuum_vacuum_scale_factor  => $autovacuum_vacuum_scale_factor,
        autovacuum_analyze_scale_factor => $autovacuum_analyze_scale_factor,
        autovacuum_freeze_max_age       => $autovacuum_freeze_max_age,
        autovacuum_vacuum_cost_delay    => $autovacuum_vacuum_cost_delay,
        autovacuum_vacuum_cost_limit    => $autovacuum_vacuum_cost_limit,
    }    
}

