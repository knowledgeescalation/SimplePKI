# SimplePKI

SimplePKI is a lightweight, bash-based toolkit for creating and managing a simple Public Key Infrastructure (PKI). It allows you to easily generate a Root Certificate Authority (CA) and issue server certificates signed by your CA using Elliptic Curve Cryptography (ECC).

## Features

- Create a self-signed Root CA certificate
- Generate server certificates signed by your CA
- Automatically include proper DNS entries in certificates
- Uses modern ECC cryptography (secp384r1 curve) for enhanced security
- Simple command-line interface for all operations

## Prerequisites

- Bash shell environment
- OpenSSL installed on your system

## Installation

1. Clone this repository:
```bash
git clone https://github.com/knowledgeescalation/SimplePKI.git
cd SimplePKI
```

2. Make scripts executable:
```bash
chmod +x *.sh
```

## Usage

### Creating a Root CA

To create your own Certificate Authority, run:

```bash
./gen-ca.sh
```

You'll be prompted to enter the following information:

- Country (two-letter country code)
- State/Province
- Locality/City
- Organization
- Common Name for your CA

The script will:

- Create necessary directories (root-ca, crl, certs, new_certs, csr)
- Generate an ECC private key for your CA
- Create a self-signed CA certificate valid for 5 years
- Generate a random serial number
- Create a `gen-cert.sh` script for issuing certificates

### Generating Server Certificates

After creating your CA, you can generate server certificates by running:

```bash
./gen-cert.sh
```

You'll be prompted to enter the server's DNS name. The script will:

- Generate an ECC key pair for the server
- Create a Certificate Signing Request (CSR)
- Set up proper DNS entries in the Subject Alternative Name extension
- Issue and sign the certificate with your CA


## File Structure

- `gen-ca.sh`: Script to set up the Root CA
- `gen-cert.sh`: Script generated by gen-ca.sh to issue server certificates
- `gen-ext.sh`: Helper script to create extension configurations
- `clean.sh`: Utility to clean up generated files
- `revoke.sh`: Script for certificate revocation
- `root-ca.conf`: Configuration file for the Root CA


## Generated Directory Structure

After running the scripts, the following directory structure is created:

```
SimplePKI/
├── root-ca/      # Contains CA key and certificate
├── certs/        # Server certificates and keys
├── csr/          # Certificate signing requests
├── crl/          # Certificate revocation lists
├── new_certs/    # Copy of issued certificates
└── index.txt     # Database of issued certificates
```

