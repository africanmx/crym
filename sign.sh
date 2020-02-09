#!/bin/bash
# this signer must be in the same place as the crym binary, so this should always leave at /usr/lib/crym or wherever the crym points to, but if termux,
# then the installation is via luis binary and it does not have programmed features like auto updates and all that shit
# unless it does so it means that you can ignore everything
TMPFILE=$( [[ "$SHELL" =~ rmux ]] && ( mkdir -p ~/.tmp && echo ~/.tmp ) || echo /tmp )/$(cat /dev/urandom | tr -dc '0-9a-f' | fold -w 31 | head -n 1 | sed -e 's/\(........\)\(....\)\(...\)\(....\)\(............\)/\1-\2-4\3-\4-\5/')
# korn did it again # oops korn did it again, she played with your hearth, now its korn shell minicoooolt yeeeee eee # ooops kornshell did it again, casi hasta el finaaaaa aaa aall deldalalinea, dale baby one more timeeee mmmm ba #
dcs(){ echo "$@" >&2 && exit 1; }
run(){
	[[ ! -x $(command -v sha256sum) ]] && dcs "sign.sh requires sha256sum"
	head -n 16 ./crym | tail -n 1 | cut -d= -f2 > $TMPFILE
	while IFS=' ' read VAR; do
		ARR+=($VAR)
	done < $TMPFILE
	[[ ${#ARR[@]} -ne 4 ]] && dcs "crym var line is invalid"
	PROGRAM_SIGN=${ARR[3]}
	CRYMSUM=$(sha256sum ./crym)
	SIGNATURE=$(cat <<EOF
{
  "PROGRAM_NAME":"${ARR[1]}",
  "PROGRAM_VERSION":"${ARR[2]}",
  "PROGRAM_SIGN":"$PROGRAM_SIGN",
  "PROGRAM_SUM":"$CRYMSUM"
}
EOF
)
	echo "$SIGNATURE"> ./$PROGRAM_SIGN
	rm "$TMPFILE"
}
run "$@"
