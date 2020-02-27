#!/bin/bash
# Copyright 2020, Luis Pulido Diaz
THECRYM=./crym
run(){
	PROGRAM_NAME=crym
	PROGRAM_VERSION=0.1
	XCMD=$PROGRAM_NAME
	case "$SHELL" in
		*ermux*)
			# nasty onliner but nice af
			curl -o ~/../usr/bin/crym https://raw.githubusercontent.com/africanmx/crym/dev/crym && chmod +x ~/../usr/bin/crym && echo "Done" && return
		;;
		*) ;;
	esac
	[[ $(id -u) -eq 0 ]] && AMIROOT=1 || AMIROOT=0
	PROGRAM_ROOT=/usr/lib/$PROGRAM_NAME
	PROGRAM_KEYFR=$PROGRAM_ROOT/.platinumd
	PROGRAM_KEYFN=(.pkeyf .pskeyf)
	[[ -d "$PROGRAM_ROOT" && -f "$PROGRAM_BAMBUCHA" ]] && INSTALLEDALREADY=1 || INSTALLEDALREADY=0
	[[ -f "$PROGRAM_KEYFR/${PROGRAM_KEYFN[0]}" && -f "$PROGRAM_KEYFR/${PROGRAM_KEYFN[1]}" ]] && NOKEY=0 || NOKEY=1
	[[ "$INSTALLEDALREADY" -eq 1 ]] && dcs "crym is installed already, or at least $PROGRAM_BAMBUCHA is present already"
	[[ "$AMIROOT" -ne 1 ]] && dcs "you or your masteruser must be root so try run as sudo"
	echo "Installing..."
	mkdir -p "$PROGRAM_ROOT" && echo "Created directory $PROGRAM_ROOT"
	cp "$THECRYM" "$PROGRAM_ROOT/$PROGRAM_NAME" && echo "Copied program from $THECRYM to $PROGRAM_ROOT/$PROGRAM_NAME"
	if [[ -f ./sign.sh ]] ; then
		cp ./sign.sh "$PROGRAM_ROOT/sign.sh"
		( cd $PROGRAM_ROOT && ./sign.sh )
		echo "Copied signer and signed crym"
	fi
	( cd $PROGRAM_ROOT && ln -s $(pwd)/$PROGRAM_NAME /usr/local/bin/$PROGRAM_NAME ) && echo "Created link in /usr/local/bin so program is executable now"
}
run
