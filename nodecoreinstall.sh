#!/usr/bin/env bash
#
# Install Java:
#
echo "Installing Java if needed..."
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' software-properties-common | grep "install ok installed" | cut -d' ' -f2)
echo Checking for software-properties-common: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No software-properties-common. Setting up software-properties-common."
    sudo apt-get update
    sudo apt-get install software-properties-common -qq
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' oracle-java8-installer | grep "install ok installed" | cut -d' ' -f2)
echo Checking for oracle-java8-installer: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No oracle-java8-installer. Setting up oracle-java8-installer."
    if ! grep -q "ppa:webupd8team/java" /etc/apt/sources.list; then
        echo "Adding repo for Java installation..."
        sudo add-apt-repository ppa:webupd8team/java -y
    fi
    sudo apt-get update
    sudo apt-get install oracle-java8-installer -qq
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' oracle-java8-set-default|grep "install ok installed" | cut -d' ' -f2)
echo Checking for oracle-java8-set-default: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No oracle-java8-set-default. Setting up oracle-java8-set-default."
    sudo apt-get install oracle-java8-set-default -qq
fi
#
# Install Other Dependencies:
#
echo "Installing other dependencies if needed..."
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' jq | grep "install ok installed" | cut -d' ' -f2)
echo Checking for jq: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No jq. Setting up jq."
    sudo apt-get install jq -qq
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' unzip | grep "install ok installed" | cut -d' ' -f2)
echo Checking for unzip: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No unzip. Setting up unzip."
    sudo apt-get install unzip -qq
fi
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' screen | grep "install ok installed" | cut -d' ' -f2)
echo Checking for screen: $PKG_OK
if [ "" == "$PKG_OK" ]; then
    echo "No screen. Setting up screen."
    sudo apt-get install screen -qq
fi
#
# Get url for latest nodecore version
#
LATEST_NODECORE=`curl -s https://explore.veriblock.org/api/stats/download | jq -r .nodecore_all_tar`
NODECORE="$(cut -d'/' -f9 <<<$LATEST_NODECORE)"
NODECORE_ALL_DIR="$(echo "$NODECORE" | cut -d'.' -f1-3)"
NODECORE_DIR="$(echo "$NODECORE" | cut -d'-' -f2,4 | cut -d'.' -f1-3)"
#
echo "Creating directory for latest release..."
mkdir $NODECORE_ALL_DIR
cd $NODECORE_ALL_DIR
#
# Download latest version of nodecore & bootstrap
#
echo "Downloading $LATEST_NODECORE..."
wget -q --show-progress $LATEST_NODECORE
echo "Extracting $NODECORE..."
tar xvf $NODECORE
cd $NODECORE_DIR
cd ../bin
chmod +x nodecore
