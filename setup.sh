#!/usr/bin/env zsh

# Parse arguments
isInteractive=0
showHelp() {
	echo "-i          Interactive use"
	echo "-a <string> Hostname (no port or username)"
	echo "-p <string> Port"
	echo "-u <string> Username"
	echo "-k <string> Private key location (absolute path)"
	exit 1
}
while getopts ":ia:p:u:k:" opt; do
	case $opt in
		i)
			isInteractive=1
			;;
		a)
			jaddress=$OPTARG
			;;
		p)
			jport=$OPTARG
			;;
		u)
			juser=$OPTARG
			;;
		k)
			jkey=$OPTARG
			;;
		*)
			showHelp
			;;
	esac
done
shift $((OPTIND-1))

# Validate arguments
[[ $isInteractive = 1 ]] && [[ -v jaddress ]] && showHelp
[[ $isInteractive = 1 ]] && [[ -v jport ]] && showHelp
[[ $isInteractive = 1 ]] && [[ -v juser ]] && showHelp
[[ $isInteractive = 1 ]] && [[ -v jkey ]] && showHelp
[[ $isInteractive = 0 ]] && [[ -v jaddress ]] || showHelp
[[ $isInteractive = 0 ]] && [[ -v jport ]] || showHelp
[[ $isInteractive = 0 ]] && [[ -v juser ]] || showHelp
[[ $isInteractive = 0 ]] && [[ -v jkey ]] || showHelp

# Get input and confirm if interactive
[[ $isInteractive = 1 ]] && {
	echo -e "\033[01mHostname\033[0m (no port or user)\033[01m:\033[0m"
	read jaddress
	echo -e "\033[01mPort:\033[0m"
	read jport
	echo -e "\033[01mUsername:\033[0m"
	read juser
	echo -e "\033[01mPrivate key location\033[0m (absolute path)\033[01m:\033[0m"
	read jkey
	echo -e "Settings:
		\033[01mAddress:\033[0m  $jaddress
		\033[01mPort:\033[0m	 $jport
		\033[01mUser:\033[0m	 $juser
		\033[01mKey path:\033[0m $jkey"
	while [[ $confirmAnswer != y ]]
	do
		echo -e "Type \033[32my\033[0m to confirm or \033[31mn\033[0m to cancel."
		read confirmAnswer
		[[ $confirmAnswer = n ]] && exit 0
	done
}

# Go to repo directory
repoDirPre=$(dirname $0)
cd $repoDirPre
repoDir=$PWD

# Rebuild directories
echo Rebuilding directories...
serviceDir=/etc/systemd/system/com.cadnza.reverseShellService
[[ -d $serviceDir ]] && sudo rm -rf $serviceDir
sudo mkdir $serviceDir

# Link main script
echo Linking support files...
sudo ln -s "$repoDir"/main.sh $serviceDir/main.sh

# Write files
echo Writing files...
echo $jaddress | sudo tee $serviceDir/address &> /dev/null
echo $jport | sudo tee $serviceDir/port &> /dev/null
echo $juser | sudo tee $serviceDir/user &> /dev/null
echo $jkey | sudo tee $serviceDir/key &> /dev/null

# Enable service
serviceFile=$repoDir/com.cadnza.reverseShellService.service
echo Enabling service...
sudo systemctl enable $serviceFile

# Echo done
echo -e "\033[01mDone!\033[0m"

# Echo instructions
echo Please run the following commands to start the service:
echo "	\033[32msudo systemctl daemon-reload\033[0m"
echo "	\033[32msudo systemctl start com.cadnza.reverseShellService.service\033[0m"

# Exit
exit 0
