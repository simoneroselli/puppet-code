
define client-init::user(
  $ldap_uri,
  $ldap_base,
  ) {

  include client-init

  case $operatingsystem {
    debian, ubuntu: {
      $ldap_cfg      = 'ldap.conf'
      $ldap_cfg_path = '/etc/ldap/ldap.conf'
      $ldap_cfg_tmpl = 'client-init/ldap.conf.deb.erb'
    }
  }

  file { $ldap_cfg :
    ensure  => file,
    require => $client_pkg,
    path    => $ldap_cfg_path,
    content => template($ldap_cfg_tmpl),
  }
}
