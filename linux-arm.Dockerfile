FROM hotio/base@sha256:5193797b5db238405f64036a60a0f59d425050bc10cfc708eccd91cf5f38c18a

ARG DEBIAN_FRONTEND="noninteractive"

ARG APPRISE_VERSION=0.8.3

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        cron \
        python3-pip python3-setuptools && \
    pip3 install --no-cache-dir --upgrade apprise==${APPRISE_VERSION} && \
# clean up
    apt purge -y python3-pip python3-setuptools && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# https://github.com/restic/restic/releases
# https://github.com/ncw/rclone/releases
ARG RESTIC_VERSION=0.9.6
ARG RCLONE_VERSION=1.50.2

# install restic
RUN curl -fsSL "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_arm.bz2" | bunzip2 | dd of=/usr/local/bin/restic && chmod 755 /usr/local/bin/restic && \
# install rclone
    debfile="/tmp/rclone.deb" && curl -fsSL -o "${debfile}" "https://github.com/ncw/rclone/releases/download/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-arm.deb" && dpkg --install "${debfile}" && rm "${debfile}"

COPY root/ /
