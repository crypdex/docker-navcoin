#!/usr/bin/env bash

##########################################
# Run this script with Makefile from root
# VERSION=0.17 make release
##########################################

ORG="crypdex"
SERVICE="navcoin"
VERSION='4.5'
ARCH="arm64v8 x86_64"

# Build and push builds for these architectures
for arch in ${ARCH}; do
  if [[ ${arch} = "arm64v8" ]]; then
    IMAGE="arm64v8/debian:stable-slim"
    NAVCOIN_ARCH="aarch64"
  elif [[ ${arch} = "x86_64" ]]; then
    IMAGE="debian:stable-slim"
    NAVCOIN_ARCH="x86_64"
  fi

  echo "=> Building NavCoin {arch: ${arch}, image: ${IMAGE}, navcoin-arch: ${NAVCOIN_ARCH}}"

  docker build -f ${VERSION}/Dockerfile -t ${ORG}/${SERVICE}:${VERSION}-${arch} --build-arg NAVCOIN_ARCH=${NAVCOIN_ARCH} --build-arg IMAGE=${IMAGE} ${VERSION}/.
  docker push ${ORG}/${SERVICE}:${VERSION}-${arch}
done


# Now create a manifest that points from latest to the specific architecture
rm -rf ~/.docker/manifests/*

# version
docker manifest create ${ORG}/${SERVICE}:${VERSION} ${ORG}/${SERVICE}:${VERSION}-x86_64 ${ORG}/${SERVICE}:${VERSION}-arm64v8
docker manifest push ${ORG}/${SERVICE}:${VERSION}

