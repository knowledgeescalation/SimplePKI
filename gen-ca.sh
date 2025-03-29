#!/bin/bash

echo
echo -------------------------------------------
echo Provide information for Root CA certificate.
echo -------------------------------------------

echo -n "Country (two-letter country code): "
read -r C
echo -n "State/Province: "
read -r ST
echo -n "Locality/City: "
read -r L
echo -n "Organization: "
read -r O
echo -n "Common Name: "
read -r CN

ecc=secp384r1

echo Generating directories...
mkdir root-ca crl certs new_certs csr 
touch index.txt

echo ECC: $ecc
echo Generating ecc private and public key...
openssl ecparam -genkey -name $ecc -out root-ca/ca.key
if [ $? -ne 0 ]; then
    	echo "Command failed. Exiting."
fi

echo Generating self-signed certificate...
openssl req -new -x509 -sha256 -key root-ca/ca.key -out root-ca/ca.crt -days 1825 -subj "/C=$C/ST=$ST/L=$L/O=$O/CN=$CN"
if [ $? -ne 0 ]; then
        clean
        echo "Command failed. Exiting."
	exit 1
fi

echo Generating starting serial...
openssl rand -hex 8 > serial
if [ $? -ne 0 ]; then
        echo "Command failed. Exiting."
        exit 1
fi

echo Generating gen-cert.sh script...

cat <<EOF > gen-cert.sh
#!/bin/bash

echo
echo -------------------------------------------
echo Provide information for server certificate.
echo -------------------------------------------

C=$C
ST=$ST
L=$L
O=$O
echo -n "Server DNS: "
read -r CN

ecc=$ecc

echo ECC: \$ecc

SUBJ="/C=\$C/ST=\$ST/L=\$L/O=\$O/CN=\$CN"

echo Generating ecc private and public key: certs/\$CN.key
openssl ecparam -genkey -name \$ecc -out certs/\$CN.key

echo Generating ext config: \$CN.conf
./gen-ext.sh \$CN

echo Generating CSR: csr/\$CN.csr
openssl req -key certs/\$CN.key -subj \$SUBJ -new -sha256 -reqexts req_ext -config \$CN.conf -out csr/\$CN.csr
rm \$CN.conf

echo Generating certificate: certs/\$CN.crt
openssl ca -config root-ca.conf -days 1825 -extensions server_cert -notext -md sha256 -in csr/\$CN.csr -out certs/\$CN.crt

EOF

if [ $? -ne 0 ]; then
        echo "Command failed. Exiting."
        exit 1
fi

chmod +x gen-cert.sh

if [ $? -ne 0 ]; then
        echo "Command failed. Exiting."
        exit 1
fi
