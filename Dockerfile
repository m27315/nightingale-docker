FROM ubuntu:14.04
RUN apt update && apt install -y \
    autoconf \
    build-essential \
    cmake \
    firefox \
    g++ \
    git \
    gstreamer-1.0 \
    gstreamer1.0-alsa \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-pulseaudio \
    libasound2-dev \
    libdbus-glib-1-dev \
    libgnomevfs2-dev \
    libgstreamer-plugins-base1.0-dev \
    libgtk2.0-dev \
    libidl-dev \
    libnspr4-dev \
    libsqlite0-dev \
    libtag1-dev \
    pulseaudio \
    pulseaudio-utils \
    unzip \
    vim \
    xterm \
    zip \
    && \
    mkdir -p /local && \
    cd /local && \
    git clone --single-branch -b gstreamer-1.0 https://github.com/nightingale-media-player/nightingale-hacking.git && \
    cd /local/nightingale-hacking && \
    sed -i 's/sed \(.*\) nightingale/sed \1 compiled\/dist\/nightingale/g' build.sh && \
    ./build.sh && \
    make install
#RUN cd /local/nightingale-hacking/debian && dpkg-buildpackage -uc -us
CMD \
    groupadd -o -g $GID $GIDN; \
    groupadd -o -g $AID audio; \
    groupadd -o -g $AID audio2; \
    useradd -u $UID -g $GID -G sudo,audio,audio2,video,plugdev,staff,games,users -M -N -o -s /bin/bash $UIDN && \
    cd /home/$UIDN && \
    start-pulseaudio-x11 && \
    su $UIDN -c /usr/bin/nightingale
