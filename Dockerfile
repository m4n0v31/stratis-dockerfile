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

# Make the STRATIS ports available to the Docker container's host.
EXPOSE 16174

ENV STRATIS_DATA_DIR /mnt/stratis

# Copy script and set executable flag
COPY auto-stake.sh /usr/bin/auto-stake.sh
RUN chmod +x /usr/bin/auto-stake.sh

# Run the auto-stake script.
RUN mkdir -p /var/run/stratis
WORKDIR /var/run/stratis
ENTRYPOINT ["/usr/bin/auto-stake.sh"]
