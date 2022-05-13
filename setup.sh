#!/usr/bin/env zsh

# Go to repo directory
repoDir=$(dirname $0)
cd $repoDir

# Validate directories
echo Validating directories...
supportDir=/etc/systemd/support
serviceDir=$supportDir/com.jondayley.reverseShellService
dirs="$supportDir
$serviceDir"
echo $dirs | while read -r dirSingle
do
	[[ -d $dirSingle ]] || sudo mkdir $dirSingle
done

# Link main script
echo Linking support files...
sudo ln -s $repoDir/main.sh $serviceDir/main.sh

# Get input
echo "Address (no port or user):"
read jaddress
echo "Port:"
read jport
echo "User:"
read juser
echo "Private key location (absolute path):"
read jkey

# Confirm input
echo "Settings:
	Address:  $jaddress
	Port:     $jport
	User:     $juser
	Key path: $jkey"
while [[ $confirmAnswer != y ]]
do
	echo -e "Type \033[32my\033[0m to confirm or \033[31mn\033[0m to cancel."
	read confirmAnswer
	[[ $confirmAnswer = n ]] && exit 0
done

# Write files
echo Writing files...
echo $jaddress | sudo tee $serviceDir/address &> /dev/null
echo $jport | sudo tee $serviceDir/port &> /dev/null
echo $juser | sudo tee $serviceDir/user &> /dev/null
echo $jkey | sudo tee $serviceDir/key &> /dev/null

# Enable service
serviceFile=$repoDir/com.jondayley.reverseShellService.service
echo Enabling service...
sudo systemctl enable $serviceFile

# Echo done
echo Done!

# Exit
exit 0
