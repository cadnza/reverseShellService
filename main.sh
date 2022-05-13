#!/usr/bin/env zsh

# Set validation failure message
messagevf="Please run setup.sh."

# Validate directories
supportDir=/etc/systemd/support
serviceDir=$supportDir/com.jondayley.reverseShellService
[[ -d $serviceDir ]] || {
	echo $messagevf
	exit 1
}

# Read in variables
jaddress=$(cat $serviceDir/address) 2> /dev/null || {
	echo $messagevf
	exit 1
}
jport=$(cat $serviceDir/port) 2> /dev/null || {
	echo $messagevf
	exit 1
}
juser=$(cat $serviceDir/user) 2> /dev/null || {
	echo $messagevf
	exit 1
}
jkey=$(cat $serviceDir/key) 2> /dev/null || {
	echo $messagevf
	exit 1
}

# Open reverse shell
ssh -qNn \
	-o ServerAliveInterval=30 \
	-o ServerAliveCountMax=3 \
	-o ExitOnForwardFailure=yes \
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	-i "$jkey" \
	-R "$jport":localhost:22 \
	"$juser"@"$jaddress"

# Exit (formality)
exit 0
