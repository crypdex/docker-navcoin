#!/bin/bash
set -e

datadir="/home/navcoin/.navcoin"

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for navcoind"

  set -- navcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "navcoind" ]; then
  echo "Creating data directory ..."
  mkdir -p "$datadir"
  chmod 700 "$datadir"
  chown -R navcoin "$datadir"

  echo "$0: setting data directory to $datadir"

  set -- "$@" -datadir="$datadir"
fi

if [ "$1" = "navcoind" ] || [ "$1" = "navcoin-cli" ] || [ "$1" = "navcoin-tx" ]; then
  echo "$@"
  exec su-exec navcoin "$@"
fi

echo
exec "$@"
