#!/bin/bash


# Check if dependencies are installed and install if missing
DEPENDENCIES=(wget tar gcc make zlib1g-dev)
MISSING_DEPENDENCIES=()

for DEPENDENCY in ${DEPENDENCIES[@]}; do
    if ! command -v $DEPENDENCY &> /dev/null
    then
        MISSING_DEPENDENCIES+=($DEPENDENCY)
    fi
done

if [ ${#MISSING_DEPENDENCIES[@]} -gt 0 ]
then
    echo "The following dependencies are required: ${MISSING_DEPENDENCIES[*]}"
    sudo apt-get update
    sudo apt-get install -y ${MISSING_DEPENDENCIES[*]}
fi

# Get current OpenSSL version
CURRENT_VERSION=$(openssl version | awk '{print $2}')

# Check if version is less than 1.1.1t
if [ "$(printf '%s\n' "$CURRENT_VERSION" "1.1.1t" | sort -V | head -n1)" != "1.1.1t" ]; then
    # Install OpenSSL 1.1.1t
    echo "OpenSSL version $CURRENT_VERSION is not up-to-date. Installing OpenSSL version 1.1.1t..."
    cd /tmp
    wget --no-check-certificate https://www.openssl.org/source/openssl-1.1.1t.tar.gz
    tar -zxvf openssl-1.1.1t.tar.gz
    cd openssl-1.1.1t
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
    make
    sudo make install

    # Configure OpenSSL shared libraries
    sudo sh -c 'echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/openssl-1.1.1t.conf'
    sudo ldconfig

    # Configure OpenSSL binary
    sudo update-alternatives --install /usr/bin/openssl openssl /usr/local/ssl/bin/openssl 1

    # Check if installation was successful
    if [ "$(openssl version | awk '{print $2}')" == "1.1.1t" ]; then
        echo "OpenSSL version 1.1.1t has been installed."
    else
        echo "OpenSSL installation failed."
    fi

    # Delete the zip/tar file. 
    cd /tmp
    rm -rf openssl-1.1.1t openssl-1.1.1t.tar.gz
else
    echo "OpenSSL version $CURRENT_VERSION is up-to-date."
fi


# Display the current OpenSSL version
echo "Current OpenSSL version: $(openssl version | awk '{print $2}')"
