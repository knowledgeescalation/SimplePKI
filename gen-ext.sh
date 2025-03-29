#!/bin/bash

if [ $# -lt 1 ]; then
    echo "No arguments provided."
    exit 1
fi

CN=$1

cat <<EOF > $CN.conf
[req]
distinguished_name              = dn
req_extensions                  = req_ext

[dn]

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1   = $CN
DNS.2   = www.$CN
EOF
