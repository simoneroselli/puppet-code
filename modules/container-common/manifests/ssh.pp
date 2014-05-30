# SSH type
#

define container-common::ssh(
    $admin_pub_keys,
    ) {

    include container-common

    file { "/root/.ssh/authorized_keys":
        ensure  => present,
        content => template("container-common/authorized_keys.erb"),
    }
}
