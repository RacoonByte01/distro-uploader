#!/bin/sh

#Load downloaders
# grep 'VERSION=' downloaders/* | sed 's/VERSION=//'

test=($(find downloaders -type f | sort))
# echo ${#test[@]}
echo "- [*] Starting ${#test[@]} updaters"
for i in ${test[@]}
do
    DISTRO=$(grep 'DISTRO=' $i | sed 's/DISTRO=//')
    SAVEAS=$(grep 'SAVEAS=' $i | sed 's/SAVEAS=//')
    VERSION=$(grep 'VERSION=' $i | sed 's/VERSION=//' | sh)
    URL_DOWNLOAD=$(echo $(grep 'DOWNLOAD=' $i | sed 's/DOWNLOAD=//') | sed -e "s/version/$VERSION/")
    CHEKSUM=$(grep "CHEKSUM=" $i | sed 's/CHEKSUM=//' | sh)
    CHEKSUM_TYPE=$(grep 'CHEKSUM_TYPE=' $i | sed 's/CHEKSUM_TYPE=//')
    SAMESUM=0
    echo "- [*] Starting $DISTRO v.($VERSION) update..."
    echo "- [+] Exsist a file in location..."
    if [[ -f $SAVEAS  ]]
    then
        echo '- [+] Yes, exsist a file in location'
        echo '- [+] Checking signature of local file'
        # echo "$CHEKSUM_TYPE $SAVEAS" 
        LOCALFILESUM=$(sh -c "$CHEKSUM_TYPE $SAVEAS | awk '{printf \$1}'")
        echo '- [+] Local Checksum: ' $LOCALFILESUM
        echo '- [+] Download Checksum: ' $CHEKSUM
        SAMESUM=$([[ "$LOCALFILESUM" == "$CHEKSUM" ]] && echo 1 || echo 0)
        [[ $SAMESUM == 1 ]] \
            && echo '- [+] The signature is correct' \
            || echo '- [e] The signature is incorrect'
    else
        echo '- [e] No, exsist a file in location'
    fi
    echo "- [+] End Checking signature..."
    if [[ $SAMESUM == 0 ]]
    then
        echo "- [+] Starting downloading..."
        curl --progress-bar $URL_DOWNLOAD -o $SAVEAS
        echo "- [+] End download..."
    fi
    echo "- [*] End $DISTRO update." 
done
echo '- [*] End all updaters'