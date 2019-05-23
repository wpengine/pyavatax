#!/bin/sh

# This file is called from Makefile, and run in the context of a Docker image.
# It makes sure that the package we built reports the correct semantic version.

set -e

PKG_NAME="pyavataxwpe"

main()
{
    if [ -z "$SEMVER" ]; then
        die "The SEMVER environment variable must be present."
    fi

    # We expect the output of sdist to be here:
    SDIST_FILE="dist/${PKG_NAME}-${SEMVER}.tar.gz"
    [ -f "$SDIST_FILE" ] || die "No such file: $SDIST_FILE"

    pip install --no-deps "$SDIST_FILE"

    EXPECTED="Version: $SEMVER"
    FOUND="$(pip show "$PKG_NAME" | grep ^Version)"

    if [ "$EXPECTED" != "$FOUND" ]; then
        echo "Expected: $EXPECTED"
        echo "Found: $FOUND"
        die "Semantic version information is inconsistent."
    fi

}

die()
{
    echo "ERROR: $*"
    exit 1
}

main "$@"
