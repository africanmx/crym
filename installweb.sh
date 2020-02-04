#!/bin/bash
# Copyright 2020, Luis Pulido Diaz
THECRYM=./crym
# you can replace this with the github raurl:
# https://raw.githubusercontent.com/africanmx/crym/dev/crym
THEURL=https://luispulido.com/nextbins/crym/crym
bambuchasig(){
	(
		cd "$(dirname $1)"
		sha256sum "$(basename $1)" > "$2"
	)
}
run(){
	[[ ! -f "$THECRYM" ]] && echo "crym binary must be present"
	PROGRAM_NAME=crym
	PROGRAM_VERSION=0.1
	XCMD=$PROGRAM_NAME
	PROGRAM_ROOT=/usr/lib/$PROGRAM_NAME
	[[ $(id -u) -eq 0 ]] && AMIROOT=1 || AMIROOT=0
	PROGRAM_BAMBUCHA=$PROGRAM_ROOT/bambuchaf
	PROGRAM_KEYFR=$PROGRAM_ROOT/.platinumd
	PROGRAM_KEYFN=(.pkeyf .pskeyf)
	[[ -d "$PROGRAM_ROOT" && -f "$PROGRAM_BAMBUCHA" ]] && INSTALLEDALREADY=1 || INSTALLEDALREADY=0
	[[ -f "$PROGRAM_KEYFR/${PROGRAM_KEYFN[0]}" && -f "$PROGRAM_KEYFR/${PROGRAM_KEYFN[1]}" ]] && NOKEY=0 || NOKEY=1
	[[ "$INSTALLEDALREADY" -eq 1 ]] && dcs "crym is installed already, or at least $PROGRAM_BAMBUCHA is present already"
	[[ "$AMIROOT" -ne 1 ]] && dcs "you or your masteruser must be root so try run as sudo"
	echo "Installing..."
	mkdir -p "$PROGRAM_ROOT" && echo "Created directory $PROGRAM_ROOT"
	touch "$PROGRAM_BAMBUCHA" && echo "Created file $PROGRAM_BAMBUCHA"
	curl -o "$PROGRAM_ROOT/$PROGRAM_NAME" "$THEURL" && echo "Downloaded the crym program from $THEURL to $PROGRAM_ROOT/$PROGRAM_NAME"
	[[ ! -f "$PROGRAM_ROOT/$PROGRAM_NAME" ]] && echo "Error. The file could not be downloaded. Try running with higher permissions" && exit 1
	chmod +x "$PROGRAM_ROOT/$PROGRAM_NAME"
	[[ ! -x "$(command -v sha256sum)" ]] && warn "Warning: Not signed because sha256sum is not present" || bambuchasig "$PROGRAM_ROOT/$PROGRAM_NAME" "$PROGRAM_BAMBUCHA"
	( cd $PROGRAM_ROOT && ln -s $(pwd)/$PROGRAM_NAME /usr/local/bin/$PROGRAM_NAME ) && echo "Created link in /usr/local/bin so program is executable now"
}
run
