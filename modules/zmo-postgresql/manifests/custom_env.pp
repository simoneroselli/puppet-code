# Puppet postgresql custom_env class:  Given a custom postgresql data_dir,
# create it, rename the default one in ".orig", copy the content to the custom
# dir, insert a README with a short explanation into the default location.

class postgresql::custom_env inherits postgresql::postgresql_conf {

  # Create the custom directory
  exec { 'setup_psql_datadir':
    onlyif  => "/usr/bin/test ! -d ${data_directory}",
    command => "/bin/mkdir -p ${data_directory}",
    require => Class['postgresql::postgresql_conf']

  }

  exec { 'copy_default_datadir':
    command => "/bin/cp -a ${postgresql_default_dir}/* ${data_directory}",
    onlyif  => "/usr/bin/find ${data_directory} -maxdepth 0 -empty | read v",
    require => Exec['setup_psql_datadir']
  }

  exec {'rename_orig_datadir':
    command =>"/bin/mv ${postgresql_default_dir} ${postgresql_default_dir}.orig",
    onlyif  => "/usr/bin/test ! -d ${postgresql_default_dir}.orig",
    require => Exec['copy_default_datadir']
  }

  file { "${postgresql_default_dir}/../README.please":
    ensure   => present,
    owner    => "root",
    group    => "root",
    mode     => 0644,
    require  => Exec['rename_orig_datadir'],
    content  => template('postgresql/README.erb'),
  }
}