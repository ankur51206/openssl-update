
#!/bin/bash


This line specifies that the script should be executed using the Bash shell.




DEPENDENCIES=(wget tar gcc make zlib1g-dev)
MISSING_DEPENDENCIES=()


These lines define two arrays: DEPENDENCIES contains the names of the packages that need to be installed, and MISSING_DEPENDENCIES will be used to store the names of any packages that are missing.





for DEPENDENCY in ${DEPENDENCIES[@]}; do
    if ! command -v $DEPENDENCY &> /dev/null
    then
        MISSING_DEPENDENCIES+=($DEPENDENCY)
    fi
done


This loop iterates over the DEPENDENCIES array and checks if each package is installed by using the command -v command. If the package is not found, its name is added to the MISSING_DEPENDENCIES array.






if [ ${#MISSING_DEPENDENCIES[@]} -gt 0 ]
then
    echo "The following dependencies are required: ${MISSING_DEPENDENCIES[*]}"
    sudo apt-get update
    sudo apt-get install -y ${MISSING_DEPENDENCIES[*]}
fi


This block of code checks whether any dependencies are missing by checking the length of the MISSING_DEPENDENCIES array. If there are missing dependencies, a message is printed and the sudo apt-get install command is used to install them.





CURRENT_VERSION=$(openssl version | awk '{print $2}')


This line uses the openssl version command to get the current version of OpenSSL and stores it in the CURRENT_VERSION variable.




if [ "$(printf '%s\n' "$CURRENT_VERSION" "1.1.1t" | sort -V | head -n1)" != "1.1.1t" ]; then


This line checks whether the current version of OpenSSL (CURRENT_VERSION) is less than 1.1.1t. It does this by using the printf command to compare the two versions and the sort -V command to sort them in version order.




echo "OpenSSL version $CURRENT_VERSION is not up-to-date. Installing OpenSSL version 1.1.1t..."
cd /tmp
wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1t.tar.gz
tar -zxvf openssl-1.1.1t.tar.gz
cd openssl-1.1.1t
./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
make
sudo make install


If the current version of OpenSSL is not up-to-date, this block of code downloads and installs version 1.1.1t. It does this by changing to the /tmp directory, downloading the tarball from the OpenSSL website, extracting it, running the ./config script with the appropriate options, and then running make and make install to build and install OpenSSL.




sudo sh -c 'echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1t.conf'
sudo ldconfig

These two lines configure the shared libraries for OpenSSL.




sudo rm /usr/bin/openssl
sudo rm /usr/include/openssl

These lines remove any existing symbolic links for OpenSSL because it was intrupte the installation 




sudo ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
sudo ln -s /usr/local/ssl/include/openssl /usr/include


These two lines create symbolic links for the OpenSSL binaries and headers in the system-wide locations /usr/bin and /usr/include respectively, so that other programs on the system can find them without needing to specify their full path. The first line creates a symbolic link named openssl in the /usr/bin directory that points to the actual openssl binary located in /usr/local/ssl/bin. This allows the openssl command to be executed from anywhere on the system without having to specify the full path to the binary.










