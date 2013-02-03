# Run the client-configure script (wol) and be aware the ethtool package is
# installed


class wol-client-conf {

  package { 'ethtool':
    ensure => installed,
  }

  file { 'wol-client-conf.sh':
    path     => '/usr/local/bin/wol-client-conf.sh',
    ensure   => present,
    mode     => 0744,
    content  => template('wol-client-conf/wol-client-conf.sh'),
    require  => Package['ethtool'],
  }

  exec { 'configure_wol':
    command => 'wol-client-conf.sh eth0',
    path    => '/usr/local/bin:/bin',
    require => file['wol-client-conf.sh'],
  }
}
