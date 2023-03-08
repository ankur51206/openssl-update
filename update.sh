#!/bin/bash

# Get current OpenSSL version
CURRENT_VERSION=$(openssl version | awk '{print $2}')

# Check if version is less than 1.1.1t
if [ "$(printf '%s\n' "$CURRENT_VERSION" "1.1.1t" | sort -V | head -n1)" != "1.1.1t" ]; then
    # Install OpenSSL 1.1.1t
    echo "OpenSSL version $CURRENT_VERSION is not up-to-date. Installing OpenSSL version 1.1.1t..."
    cd /tmp
    wget -q https://www.openssl.org/source/openssl-1.1.1t.tar.gz
    tar -zxvf openssl-1.1.1t.tar.gz
    cd openssl-1.1.1t
    ./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared zlib
    make
    sudo make install
    
    # Check if installation was successful
    if [ $? -eq 0 ]; then
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
