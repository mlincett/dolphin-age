#!/bin/bash

check() {
    command -v $1 &> /dev/null
}

if ! check "age"; then
    echo "ERROR: age not found."
fi
if ! check "prename"; then
    echo "ERROR: prename not found."
fi

# Copy files to their respective directories.
# .desktop files are copied to ServiceMenus dir for context menu on Dolphin
# and an XML file to MIME dir for files with .age extension to distinguish with an icon and a description.
SERVICEMENUS_DIRECTORY=~/.local/share/kio/servicemenus
echo "Copying files.."


mkdir -p ${SERVICEMENUS_DIRECTORY}
cp age-encrypt.desktop ${SERVICEMENUS_DIRECTORY}
cp age-decrypt.desktop ${SERVICEMENUS_DIRECTORY}
chmod +x ${SERVICEMENUS_DIRECTORY}/age-encrypt.desktop
chmod +x ${SERVICEMENUS_DIRECTORY}/age-decrypt.desktop
xdg-mime install --mode user --novendor age-mime.xml

# Create age key for current user at home folder .age-key
if [ ! -f ~/.age-key/"$(whoami).age-key" ]; then
    echo "Generating age key.."
    mkdir -p ~/.age-key && age-keygen -o ~/.age-key/"$(whoami).age-key"
    sed -n '2p' ~/.age-key/"$(whoami).age-key" > ~/.age-key/"$(whoami).pk" && sed 's/# public key: //' ~/.age-key/"$(whoami).pk" > ~/.age-key/"$(whoami)" && rm -f ~/.age-key/"$(whoami).pk" && sed -i '1i\# '$(whoami) ~/.age-key/"$(whoami)"
fi

