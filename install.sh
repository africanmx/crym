#!/bin/bash
# Copyright 2020, Luis Pulido Diaz
PROGRAM_VERSION=0.1
CRYM=crym
SIGNER=sign.sh
UPDATER=update.sh
THEBRANCH=dev
CRYMR=https://raw.githubusercontent.com/africanmx/crym/$THEBRANCH/crym
SIGNERR=https://raw.githubusercontent.com/africanmx/crym/$THEBRANCH/sign.sh
UPDATERR=https://raw.githubusercontent.com/africanmx/crym/$THEBRANCH/update.sh
run(){
	PROGRAM_NAME=$CRYM
	XCMD=$PROGRAM_NAME
	case "$SHELL" in
		*ermux*)
			# nasty onliner but nice af
			curl -o ~/../usr/bin/crym $CRYMR && chmod +x ~/../usr/bin/crym && echo "Done" && return
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
	(
		cd $PROGRAM_ROOT
		curl -O "$CRYMR"
		chmod +x ./$CRYM
		[[ -n "$VERBOSE" ]] && echo "Downloaded the CRYM from $CRYMR"
		curl -O "$SIGNERR" && echo "Downloaded the signer from $SIGNERR"
		chmod +x "$SIGNER"
		./$SIGNER && echo "Signed bin"
		curl -O "$UPDATERR" && echo "Downloaded the updater from $UPDATERR"
		chmod +x "$UPDATER"
	)
	ln -s $PROGRAM_ROOT/$PROGRAM_NAME /usr/local/bin/$PROGRAM_NAME
	echo "Created link in /usr/local/bin so program is executable now"
	echo "Updater is just there. Need to manually run it to update for now."
}
run
