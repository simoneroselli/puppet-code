# LDAP/NSS setup

define client-init::ldap(
  $ldap_uri,
  $ldap_base,
  ) {

  include client-init

  case $operatingsystem {
    debian, ubuntu: {
      $ldap_cfg      = 'ldap.conf'
      $ldap_cfg_path = '/etc/ldap/ldap.conf'
      $ldap_cfg_tmpl = 'client-init/ldap.conf.deb.erb'
      $nss_cfg       = 'nsswitch.conf'
      $nss_cfg_path  = '/etc/nsswitch.conf'
      $ldap_pkg      = ['ldap-utils', 
                        'ldap-auth-config']
    }
  }

  package { $ldap_pkg :
    ensure => installed,
  }

  file { $ldap_cfg :
    ensure  => file,
    require => Package[$ldap_pkg],
    path    => $ldap_cfg_path,
    content => template($ldap_cfg_tmpl),
  }
  
  file { $nss_cfg :
    ensure  => file,
    path    => $nss_cfg_path,
    require => Package[$ldap_pkg],
    source  => "puppet:///modules/client-init/${nss_cfg}",
    }
}
