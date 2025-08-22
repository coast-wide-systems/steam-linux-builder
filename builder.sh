#!/usr/bin/env bash

. /root/.profile

USAGE=$(cat <<!
Usage: $0 [OPTION]
Build script entrypoint used to automatically run cargo in the Steam Linux SDK OCI

	release		Run a release build, equivalent to 'cargo build --release'
	debug		Run a debug build, equivalent to 'cargo build'
	clean		Clean build artifacts (only useful if using persistent builds)
	-h, --help	Print this help message
	-V, --version	Output the Rust compiler version (rustc --version)
!
)

WORKSPACE_ERROR=$(cat <<!
A supported Rust workspace is not available in $(pwd)
Verify your project directory is volume mounted to $(pwd)
with correct SELinux labels applied (usually append :z to the volume mount
command when using podman).
!
)

ARG_ERROR='Invalid argument combination, see --help for usage'

cargo_arg=
cargo_opt=
while [[ $# -gt 0 ]]; do
	case $1 in
		release)
			if ! [ -z $cargo_arg ]; then
				echo $ARG_ERROR >&2
				exit 1
			fi
			cargo_arg=build
			cargo_opt=--release
			shift
			;;
		debug)
			if ! [ -z $cargo_arg ]; then
				echo $ARG_ERROR >&2
				exit 1
			fi
			cargo_arg=build
			shift
			;;
		clean)
			if ! [ -z $cargo_arg ]; then
				echo $ARG_ERROR >&2
				exit 1
			fi
			cargo_arg=clean
			shift
			;;
		-h|--help)
			printf "%s\n" "$USAGE"
			exit 0
			;;
		-V|--version)
			rustc --version
			exit $?
			;;
		*)
			echo $ARG_ERROR >&2
			exit 1
			;;
	esac
done

if ! [ -e Cargo.toml ]; then
	printf "%s\n" "$WORKSPACE_ERROR" >&2
	exit 1
fi

APP_NAME=$(awk '$1 == "name" {gsub(/"/, "", $3); print $3}' Cargo.toml)

cargo $cargo_arg $cargo_opt
r_code=$?

case $cargo_arg in
	build)
		cp target/release/${APP_NAME} ${OUTPUT_DIR}
		;;
esac

exit $r_code
