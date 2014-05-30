# Autofs configuration

define client-init::autofs(
    $browse_mode,
    $ldap_uri,
    $search_base,
    ) {

  include client-init

  case $operatingsystem {
    debian, ubuntu: {
      $autofs_cfg      = 'autofs'
      $autofs_cfg_path = '/etc/default/autofs'
      $autofs_cfg_tmpl = 'client-init/autofs.deb.erb'
      $autofs_pkg      = [ 'autofs', 'autofs-ldap' ]
    }
  }

  package { $autofs_pkg :
    ensure => installed,
  }

  file { $autofs_cfg :
    ensure => file,
    require => Package[$autofs_pkg],
    path    => $autofs_cfg_path,
    content => template($autofs_cfg_tmpl),
  }
}







