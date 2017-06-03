# Based on Michael Lynch's Sia on Docker Guide (https://mtlynch.io/sia-via-docker/)
FROM debian:jessie-slim
MAINTAINER Erik Rogers <erik.rogers@live.com>

ENV STRATIS_PACKAGE stratisX
ENV STRATIS_REPO https://github.com/stratisproject/${STRATIS_PACKAGE}.git

RUN apt-get update && apt-get install -y \
  build-essential \
  git \
  g++ \
  libtool \
  make \
  libboost-all-dev \
  libssl-dev \
  libdb++-dev \
  libdb5.3++-dev \
  libdb5.3-dev \
  libminiupnpc-dev \
  libqrencode-dev \
  socat \
  wget \
  unzip \
  && rm -rf /var/cache/apk/*

# Clone and build from source, then install to /usr/bin
WORKDIR /tmp
RUN git clone $STRATIS_REPO \
  && cd $STRATIS_PACKAGE/src \
  && make -f makefile.unix \
  && strip stratisd \
  && mv stratisd /usr/bin \
  && rm -rf /tmp/$STRATIS_PACKAGE

# Make the STRATIS ports available to the Docker container's host (--publish 16174:8000 from host).
EXPOSE 8000

# Configure the STRATIS daemon to run when the container starts
# Forward 8000 to localhost:45443 so it's accessible outside the container.
# Specify the STRATIS directory as /mnt/stratis so that you can view these files outside
# of Docker.
ENTRYPOINT socat tcp-listen:8000,reuseaddr,fork tcp:localhost:16174 & stratisd -datadir=/mnt/stratis
