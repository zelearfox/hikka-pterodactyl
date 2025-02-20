FROM        --platform=$TARGETOS/$TARGETARCH python:3.8-slim-bookworm

LABEL       author="ZelearFox" maintainer="fox@zlr.su"

ENV         PTERODACTYL=true
ENV         GIT_PYTHON_REFRESH=quiet

ENV         PIP_NO_CACHE_DIR=1 \
            PYTHONUNBUFFERED=1 \
            PYTHONDONTWRITEBYTECODE=1

RUN         apt update \
            && apt -y install git gcc g++ ca-certificates dnsutils curl iproute2 ffmpeg procps tini \
            && apt install libcairo2 build-essential -y --no-install-recommends \
            && useradd -m -d /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

STOPSIGNAL SIGINT

COPY        --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN         chmod +x /entrypoint.sh
ENTRYPOINT    ["/usr/bin/tini", "-g", "--"]
CMD         ["/entrypoint.sh"]