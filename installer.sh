#!/bin/bash
 
# Prompts
distroPromptText="
Which Linux distribution are you using? (If it's not listed, it's not supported by this installer and you'll have to install Grapejuice normally) 
Debian - 1 
Ubuntu - 2 
Zorin - 3 
Linux Mint - 4"

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

# Distro Sorting
distroSorts=(
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

# Executions
downloadDevBranch="git clone -b dev https://github.com/CheeseGodRoblox/GrapejuiceInstaller"

# Uneditable Variables
userDistro=""


installPackages(){
eval "$downloadDevBranch"
local wineVersion=`wine --version`
echo $wineUpgradePromptText
echo $wineVersion
read upgradeResponse
if [[ $upgradeResponse == "y" ]]
then
	eval "`cat ./GrapejuiceInstaller/WineInstallations/"$2"`"
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


installScriptDependencies(){
sudo apt install git
}

distroPrompt(){
installScriptDependencies
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
else
	echo $standardInvalidInputError
	distroPrompt
fi


for distroMatch in "${distroSorts[@]}"
do
	IFS="-"
	read actualDistro similarDistro <<< $distroMatch
	if [[ $actualDistro == $userDistro ]]
	then
		installPackages $userDistro $similarDistro
	fi
done
}

distroPrompt

/bin/bash
