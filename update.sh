#!/bin/bash

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
    echo 'export PATH="/usr/local/ssl/bin:$PATH"' | sudo tee -a /etc/environment > /dev/null
    source /etc/environment

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