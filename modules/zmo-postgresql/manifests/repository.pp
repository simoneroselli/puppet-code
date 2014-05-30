class postgresql::repository {
  
  $pgdg_package = 'pgdg-keyring'

  case $::operatingsystem {
	Debian: {

	  class { 'apt': }
	
	  apt::source { 'postgresql_releases': 
        location   		  => 'http://apt.postgresql.org/pub/repos/apt/',
        release    		  => 'wheezy-pgdg',
        repos      		  => 'main', 
        key        		  => 'ACCC4CF8', 
        key_server 		  => 'subkeys.pgp.net',
      }

	   package { $pgdg_package :
  	 	ensure  => present,
  	 	require => Apt::Source['postgresql_releases'],
  	   }
    }
    Default: {"Unknown operating system!"}
  }
}