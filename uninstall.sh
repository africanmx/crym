#!/bin/bash
# Copyright 2020, Luis Pulido Diaz
run(){
	PROGRAM_ROOT=/usr/lib/crym
	PROGRAM_NAME=crym
	# DOBACKUP=1
	[[ -n "$DOBACKUP" && -x "$(command -v zip)" ]] && zip -r $PROGRAM_ROOT/../$PROGRAM_NAME.backup.zip $PROGRAM_ROOT/*
	[[ -L "$(command -v $PROGRAM_NAME)" ]] && rm "$(command -v $PROGRAM_NAME)"
	rm -rf "$PROGRAM_ROOT"
}
run

