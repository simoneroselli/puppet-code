# Nfs configuration

define client-init::nfs-krb(
    $local_domain,
    $realm,
    ) {

  include client-init

  case $operatingsystem {
    debian, ubuntu: {
      $idmap_cfg      = 'idmapd.conf'
      $idmap_cfg_path = '/etc/idmapd.conf'
      $idmap_cfg_tmpl = 'client-init/idmapd.conf.deb.erb'
      $nfs_cfg        = 'nfs-common.deb'
      $nfs_cfg_path   = '/etc/default/nfs-common'
      $nfs_pkg        = [ 'nfs-common', 
                          'nfs-client']
    }
  }

  package { $nfs_pkg :
    ensure => installed,
  }

  file { $idmap_cfg :
    ensure  => file,
    require => Package[$nfs_pkg],
    path    => $idmap_cfg_path,
    content => template($idmap_cfg_tmpl),
  }

  file { $nfs_cfg :
      ensure  => file,
      require => Package[$nfs_pkg],
      path    => $nfs_cfg_path,
      source  => "puppet:///modules/client-init/${nfs_cfg}",
  }
}

