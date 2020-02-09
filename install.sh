#!/bin/bash
# Copyright 2020, Luis Pulido Diaz
THECRYM=./crym
bambuchasig(){
	(
		cd "$(dirname $1)"
		sha256sum "$(basename $1)" > "$2"
	)
}
run(){
	PROGRAM_NAME=crym
	PROGRAM_VERSION=0.1
	XCMD=$PROGRAM_NAME
	case "$SHELL" in
		*ermux*)
			# nasty onliner
			curl -o ~/../usr/bin/crym https://luispulido.com/nextbins/crym && chmod +x ~/../usr/bin/crym && echo "Done" && return
		;;
		*) ;;
	esac
	[[ $(id -u) -eq 0 ]] && AMIROOT=1 || AMIROOT=0
	PROGRAM_ROOT=/usr/lib/$PROGRAM_NAME
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
	cp "$THECRYM" "$PROGRAM_ROOT/$PROGRAM_NAME" && echo "Copied program from $THECRYM to $PROGRAM_ROOT/$PROGRAM_NAME"
	[[ ! -x "$(command -v sha256sum)" ]] && warn "Warning: Not signed because sha256sum is not present" || bambuchasig "$PROGRAM_ROOT/$PROGRAM_NAME" "$PROGRAM_BAMBUCHA"
	( cd $PROGRAM_ROOT && ln -s $(pwd)/$PROGRAM_NAME /usr/local/bin/$PROGRAM_NAME ) && echo "Created link in /usr/local/bin so program is executable now"
}
run
