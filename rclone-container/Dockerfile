FROM ubuntu:20.04

RUN set -ex \
    && apt-get clean \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends apt-utils apt-transport-https ca-certificates expect

COPY rclone /usr/bin/
RUN chown root:root /usr/bin/rclone \
    && chmod 755 /usr/bin/rclone

COPY scripts scripts
