#!/bin/bash

# Run this script on the host you wanna be able to wake. Basically it will configure the
# nic for understanding magick packets. It will take the first argument as
# interface name

# Usage
IF=$1
[ -z $IF ] && echo "Usage $0 <interface_name>" && exit

# Root needed
[ $UID != 0 ] && echo "Run this as root" && exit

# Check ethtool
ETHTOOL=/sbin/ethtool
[ ! -e $ETHTOOL ] && echo "Please insall ${ETHTOOL#/sbin/}" && exit

# Set the card just in the case which the interface is present and it does supports
# the wake on lan feature
if ! /sbin/ifconfig | /bin/grep -w $IF &>/dev/null; then
    echo "Interface $IF not found."
    echo "You may intend one of these:"
    echo "$(/sbin/ifconfig | /bin/grep ^eth | awk '{print $1}')"
else
    WOL=$("$ETHTOOL" -s "$IF" wol g 2>&1 >/dev/null)
    if [ ! -z "$WOL" ]; then
        echo "Your \"$IF\" card doesn't support wake on lan"
    else
        $ETHTOOL -s $IF wol g
    fi
fi
