#!/bin/sh

set -eux

IS_CONTAINER=${IS_CONTAINER:-false}
CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-podman}"

if [ "${IS_CONTAINER}" != "false" ]; then
  export XDG_CACHE_HOME=/tmp/.cache
  mkdir /tmp/unit
  cp -r ./* /tmp/unit
  cd /tmp/unit
  make unit
else
  "${CONTAINER_RUNTIME}" run --rm \
    --env IS_CONTAINER=TRUE \
    --volume "${PWD}:/metal3-ipam:ro,z" \
    --entrypoint sh \
    --workdir /metal3-ipam \
    docker.io/golang:1.18 \
    /metal3-ipam/hack/unit.sh "${@}"
fi;
