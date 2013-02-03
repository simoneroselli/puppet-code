# Client-init, setup an installed from scratch machine with the follow:
# * Nfs
# * Ldap (nss, idmapd)
# * Autofs
# * Kerberos

class client-init {
  case $operatingsystem {
    debian, ubuntu: {
      $client_pkg = ['ldap-utils', 
                     'ldap-auth-config', 
                     'nfs-common',
                     'nfs4-acl-tools'] 
                     
      $nss_cfg      = 'nsswitch.conf'
      $nss_cfg_path = '/etc/nsswitch.conf'
      
    }
  }

  package { $client_pkg :
    ensure => installed,
  }

  file { $nss_cfg :
    ensure  => file,
    path    => $nss_cfg_path,
    require => Package[$client_pkg],
    source  => "puppet:///modules/client-init/${nss_cfg}",
  }
} 
             

        
    
    
