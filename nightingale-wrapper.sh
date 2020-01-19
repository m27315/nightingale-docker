#!/bin/bash

CONTAINER_NAME=nightingale
IMAGE_NAME=docker.io/m27315/nightingale:latest
BIN_NAME=nightingale

if [ "$(docker inspect -f '{{.State.Running}}' ${CONTAINER_NAME} 2>/dev/null)" != "true" ]
then
    xhost +local:$(docker inspect --format="{{ .Config.Hostname }}" $(docker run -it --rm \
        --env="DISPLAY" --env="QT_X11_NO_MITSHM=1" --env="UID=$(id -u)" --env="UIDN=$(id -un)" \
        --env="GID=$(id -g)" --env="GIDN=$(id -gn)" --env="AID=$(getent group audio | cut -d: -f3)" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v /etc/resolv.conf:/etc/resolv.conf:ro \
        -v /home/$(id -un):/home/$(id -un) -v /run/dbus/:/run/dbus/ -v /dev/shm:/dev/shm \
        -v /dev/snd:/dev/snd -v /dev/shm:/dev/shm -v /etc/machine-id:/etc/machine-id \
        -v /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse -v /var/lib/dbus:/var/lib/dbus \
        --privileged --group-add $(getent group audio | cut -d: -f3) \
        --group-add $(getent group video | cut -d: -f3) -d --name=${CONTAINER_NAME} ${IMAGE_NAME}))
else
    docker exec "${CONTAINER_NAME}" "${BIN_NAME}" "$@"
fi
