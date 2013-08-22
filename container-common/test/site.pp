# LXC Container manifest
#

node 'container01' {
    include container-common

    container-common::ssh { 'ssh':
        admin_pub_keys => [ 'ssh-dss 09sd0f9s8d0v9s0d0s.........s0d98fs0d user@key_01',
                            'ssh-dss 09s0d9fs09d8sdfd98.........s0f098f0s user@key_02' ]
    }
}
