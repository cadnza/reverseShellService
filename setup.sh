#!/usr/bin/env zsh

# Go to repo directory
repoDirPre=$(dirname $0)
cd $repoDirPre
repoDir=$PWD

# Rebuild directories
echo Rebuilding directories...
serviceDir=/etc/systemd/system/com.jondayley.reverseShellService
[[ -d $serviceDir ]] && sudo rm -rf $serviceDir
sudo mkdir $serviceDir

# Link main script
echo Linking support files...
sudo ln -s "$repoDir"/main.sh $serviceDir/main.sh

# Get input
echo -e "\033[01mAddress\033[0m (no port or user)\033[01m:\033[0m"
read jaddress
echo -e "\033[01mPort:\033[0m"
read jport
echo -e "\033[01mUser:\033[0m"
read juser
echo -e "\033[01mPrivate key location\033[0m (absolute path)\033[01m:\033[0m"
read jkey

# Confirm input
echo -e "Settings:
	\033[01mAddress:\033[0m  $jaddress
	\033[01mPort:\033[0m     $jport
	\033[01mUser:\033[0m     $juser
	\033[01mKey path:\033[0m $jkey"
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
echo -e "\033[01mDone!\033[0m"

# Echo instructions
echo Please run the following commands to start the service:
echo "	\033[32msudo systemctl daemon-reload\033[0m"
echo "	\033[32msudo systemctl start com.jondayley.reverseShellService.service\033[0m"

# Exit
exit 0
