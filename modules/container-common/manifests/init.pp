# Container-common puppet manifest
#

class container-common {
    case $operatingsystem {
        debian, ubuntu: {
            $common_packages = ['ssh', 'vim', 'ntp']
        }
    }

    # Install common packages
    package { $common_packages :
        ensure => installed
    }

    # SSH admin pub keys
    file { "/root/.ssh":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => 700,
        require => Package[$common_packages],
        }

    file { "/etc/ssh/sshd_config":
        ensure => present,
        source => "puppet:///modules/container-common/sshd_config",
    }

    # NTP
    file { "/etc/ntp.conf":
        ensure => present,
        source => "puppet:///modules/container-common/ntp.conf",
        require => Package[$common_packages],
    }
}



