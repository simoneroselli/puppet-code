define activemq::deploy {

	include activemq::config

	user { $amq_user:
		ensure     => present,
		home 	     => $amq_home,
		shell  	   => '/bin/sh',
		managehome => yes,
	}

	file { $amq_home:
		ensure  => directory,
		owner   => $amq_user,
		group   => $amq_user,
		mask    => '0644',
		require => User[$amq_user],
	}

	# Default file (/etc/default/activemq)
	file {'/etc/default/activemq_${name}':
		ensure  => present,
		owner   => 'root',
		group   => 'root',
		mode	  => '0644',
		content => template('activemq/amq_default_file.erb'),
	}

	# Amq init script
	file {'/etc/init.d/activemq-${name}':
		ensure  => present,
		owner   => $amq_user,
		group   => $amq_user,
		mode    => '0755',
		content => template('activemq/amq_init_file.erb'),
	}

  # Grab ActiveMQ archive from the apache repository
	exec { 'download_amq_src': 
		unless  => '/usr/bin/test -e ${amq_home}/apache-activemq-${amq_version}-bin.tar.gz',
		command => 'cd /tmp && /usr/bin/wget http://archive.apache.org/dist/activemq/apache-activemq/${amq_version}/apache-activemq-${amq_version}-bin.tar.gz', 	
		require => File[$amq_home], 
	}

	# Unpack the archive in the amq user directory
	exec { 'unpack_amq_src':
		onlyif  => '/usr/bin/test -d ${amq_home}/apache-activemq-${amq_version}-bin',
		command => 'cd $amq_home && /bin/tar -xf /tmp/apache-activemq-${amq_version}-bin.tar.gz',
		require => Exec['download_amq'],
	}

	# Ensure permissions for the Amq workin directory
	file {'${amq_home}/apache-activemq-${amq_version}-bin':
		ensure  => directory,
		owner   => $amq_user,
		group   => $amq_user,
		mode    => '0644',
		recurse => true,
		require => Exec['unpack_amq_src'],
	}

	# Create a link for the ActiveMQ home
	file {'${amq_home}/activemq-${name}':
		ensure => link,
		target => '${amq_home}/apache-activemq-${amq_version}-bin',
		require => File['${amq_home}/apache-activemq-${amq_version}-bin']
	}
}






