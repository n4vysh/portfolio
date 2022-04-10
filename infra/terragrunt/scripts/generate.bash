#!/bin/bash

# age-keygen | gopass insert flux/n4vysh/portfolio/age
step \
	certificate \
	create \
	root.linkerd.cluster.local \
	environments/production/artifact/secrets/ca.crt \
	environments/production/artifact/secrets/ca.key \
	--profile root-ca \
	--no-password \
	--insecure
step \
	certificate \
	create \
	identity.linkerd.cluster.local \
	environments/production/artifact/secrets/issuer.crt \
	environments/production/artifact/secrets/issuer.key \
	--profile intermediate-ca \
	--not-after 8760h \
	--no-password \
	--insecure \
	--ca environments/production/artifact/secrets/ca.crt \
	--ca-key environments/production/artifact/secrets/ca.key
rm environments/production/artifact/secrets/ca.key

SOPS_AGE_KEY="$(gopass show -n flux/n4vysh/portfolio/age | sed -n '3p')"
export SOPS_AGE_KEY

publickey="$(gopass show -n flux/n4vysh/portfolio/age | sed -n '2p' | sed 's/# public key: //')"
sops \
	--age="$publickey" \
	--encrypt \
	--in-place environments/production/artifact/secrets/ca.crt
sops \
	--age="$publickey" \
	--encrypt \
	--in-place environments/production/artifact/secrets/issuer.crt
sops \
	--age="$publickey" \
	--encrypt \
	--in-place environments/production/artifact/secrets/issuer.key
