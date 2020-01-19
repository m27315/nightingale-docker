nightingale
===========

Runs the latest available version of the nightingale media player in a
compatible Ubuntu 14.04 host for Linux systems.

# Usage

Invoke the `nightingale-wrapper.sh` script direcly, or bind the appropriate
media keys to the following commands (assuming you put the wrapper in your
`~/bin` directory):

* Play/Pause:  `bash ~/bin/nightingale-wrapper.sh -pause`
* Next:  `bash ~/bin/nightingale-wrapper.sh -next`
* Previous:  `bash ~/bin/nightingale-wrapper.sh -previous`

# Raw Usage

The raw usage is a bit nasty, since the X display must be exported. I typically
use the script, bound to my media keys.  But, if I want to launch the player
from the command line to inspect error output in the terimainal, I use the following alias, defined in my `~/.bashrc`:

    $ alias music='xhost +local:$(docker inspect \
        --format="{{ .Config.Hostname }}" \
        $(docker run -it --rm \
            --env="DISPLAY" \
            --env="QT_X11_NO_MITSHM=1" \
            --env="UID=$(id -u)" \
            --env="UIDN=$(id -un)" \
            --env="GID=$(id -g)" \
            --env="GIDN=$(id -gn)" \
            --env="AID=$(getent group audio | cut -d: -f3)" \
            --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
            -v /etc/resolv.conf:/etc/resolv.conf:ro \
            -v /home/$(id -un):/home/$(id -un) \
            -v /run/dbus/:/run/dbus/ \
            -v /dev/shm:/dev/shm \
            -v /dev/snd:/dev/snd \
            -v /dev/shm:/dev/shm \
            -v /etc/machine-id:/etc/machine-id \
            -v /run/user/$(id -u)/pulse:/run/user/$(id -u)/pulse \
            -v /var/lib/dbus:/var/lib/dbus \
            --privileged \
            --group-add $(getent group audio | cut -d: -f3) \
            --group-add $(getent group video | cut -d: -f3) \
            -d \
            --name=nightingale \
            docker.io/m27315/nightingale:latest \
        ))'
    $ music

The alias can be added to your `~/.bashrc` or similar, so that only the `music`
command is required.

Temporary changes to `~/.bashrc` can be applied and tested using:

    $ . ~/.bashrc

# Build

Built using the following:

    $ docker build --tag=nightingale .

# Upstream

This repository is in no way affiliated or recognized by the nightingale project.

Upstream sources are available here:

* https://getnightingale.com/
* https://github.com/nightingale-media-player/nightingale-hacking
