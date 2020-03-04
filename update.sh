#!/bin/bash
# (c) 2020 Luis Pulido Diaz
# Unwarrantied
REQUIRED_COMMANDS=(sha256sum awk curl)
BACKUP=1
BACKUPD=/$(id -u)/backup
VERBOSE=1
CRYMF=/usr/lib/crym/crym
CRYMRF=https://raw.githubusercontent.com/africanmx/crym/dev/crym
SIGNER=sign.sh
dcs(){ echo "$@" >&2 && exit 1; }
signal_(){
	# This was found here: https://unix.stackexchange.com/questions/190513/shell-scripting-proper-way-to-check-for-internet-connectivity
	TRYS="$(curl -s --max-time 2 -I $CRYMRF | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')"
	[[ "$TRYS" =~ 23 ]] && echo 1
}
preload(){
	[[ $(id -u) -ne 0 ]] && dcs "This must be run as sudo"
	[[ ! -f "$CRYMF" ]] && dcs "No $CRYMF"
	for COMMAND in "${REQUIRED_COMMANDS[@]}" ; do
		[[ ! -x $(command -v $COMMAND) ]] && dcs "No sha256sum nor awk available"
	done
}
current_sum(){
	sha256sum "$CRYMF" | awk '{print $1}'
}
last_sum(){
	[[ -z "$(signal_)" ]] && dcs "Not connected to the Internet"
	(
		cd "$TMPDIR"
		curl -o "$TMPFILE" "$CRYMRF"
		sha256sum "$TMPFILE" | awk '{print $1}'
	)
}
need_update(){
	[[ "$(current_sum)" != "$(last_sum)" ]] && echo 1
}
run(){
	[[ -z "$(need_update)" ]] && return
	[[ -n "$BACKUP" ]] && mkdir -p "$BACKUPD" && cp "$CRYMF" "$BACKUPD/$BACKUPNAME"
	curl -o "$CRYMF" "$CRYMRF"
	if [[ -f "$(dirname $CRYMF)/$SIGNER" ]] ; then
		(
			cd "$(dirname $CRYMF)"
			./$SIGNER ./crym
		)
	fi
	chmod +x "$CRYMF"
	[[ -n "$VERBOSE" ]] && echo "Done"
}
