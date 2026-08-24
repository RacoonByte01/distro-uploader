#!/bin/sh

#Load downloaders
# grep 'VERSION=' downloaders/* | sed 's/VERSION=//'

test=($(find downloaders -type f | sort))
# echo ${#test[@]}

for i in ${test[@]}
do
    DISTRO=$(grep 'DISTRO=' $i | sed 's/DISTRO=//')
    SAVEAS=$(grep 'SAVEAS=' $i | sed 's/SAVEAS=//')
    VERSION=$(sh -c "$(grep 'VERSION=' $i | sed 's/VERSION=//')")
    URL_DOWNLOAD=$(echo $(grep 'DOWNLOAD=' $i | sed 's/DOWNLOAD=//') | sed -e "s/version/$VERSION/")
    echo "- [*] Starting download $DISTRO v.($VERSION)..."
    echo "- [+] Downloading..."
    curl $URL_DOWNLOAD -o $SAVEAS | pv
    echo "- [*] End download $DISTRO." 
done