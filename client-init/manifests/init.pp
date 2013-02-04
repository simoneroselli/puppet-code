# Client-init, setup an installed from scratch machine with the follow:
# * Misc (ssh, vim, git, ntp, nscd ..)
# * Nfs
# * Ldap (nss, idmapd)
# * Autofs
# * Kerberos

class client-init {
  case $operatingsystem {
    debian, ubuntu: {
      $misc_pkg = [ 'ssh', 'vim', 'git', 'nscd',
                    'ntp'] 
    }
  }

  package { $misc_pkg :
    ensure => installed,
  }

} 
             

        
    
    
