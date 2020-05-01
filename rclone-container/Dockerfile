FROM ubuntu:20.04

RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates git

COPY rclone /usr/bin/
COPY sync.sh sync.sh

RUN chown root:root /usr/bin/rclone \
    && chmod 755 /usr/bin/rclone \
    && mkdir /assets \
    && mkdir /repo


CMD sync.sh
