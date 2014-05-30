# Defined type example
# Hostname: client.local

node 'client.local' {
  
  client-init::ldap { 'ldap':
    ldap_base => 'dc=example,dc=com',
    ldap_uri  => 'ldap://ldap.example.com',
  }
  
  client-init::nfs-krb { 'nfs-krb':
    local_domain => 'local',
    realm        => 'EXAMPLE.COM', 
  }
	
}

