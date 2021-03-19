FROM ubuntu:16.04

ARG uid=1000
ARG RUST_VER=1.46.0

# TODO: Prune this
RUN apt-get update && \
    apt-get install -y \
      curl \
      cmake \
      build-essential \
      pkg-config \
      libssl-dev \
      libzmq3-dev
#       libgmp3-dev \
#       debhelper \
#       devscripts \
#       libncursesw5-dev \
#       apt-transport-https \
#       libsqlite3-dev \
#       ca-certificates \
#       wget \
#       git \
#       zip \
#       unzip \
#       jq

RUN cd /tmp && \
   curl https://download.libsodium.org/libsodium/releases/libsodium-1.0.18.tar.gz | tar -xz && \
    cd /tmp/libsodium-1.0.18 && \
    ./configure && \
    make && \
    make install && \
    ldconfig && \
    rm -rf /tmp/libsodium-1.0.18

# RUN useradd -ms /bin/bash -u $uid indy
# USER indy

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VER}
ENV PATH /root/.cargo/bin:$PATH

RUN cargo install cargo-deb cargo-bump

WORKDIR /root

COPY --chown=indy:indy libindy indy-sdk/libindy
COPY --chown=indy:indy wrappers indy-sdk/wrappers
COPY --chown=indy:indy experimental indy-sdk/experimental
COPY --chown=indy:indy libnullpay indy-sdk/libnullpay

ARG INDYSDK_PATH=/root/indy-sdk

RUN cargo build --release --manifest-path=$INDYSDK_PATH/libindy/Cargo.toml

# USER root
RUN mv $INDYSDK_PATH/libindy/target/release/libindy.so /usr/lib

# USER indy
# RUN cargo build --release --manifest-path=$INDYSDK_PATH/libnullpay/Cargo.toml
# RUN cargo build --release --manifest-path=$INDYSDK_PATH/experimental/plugins/postgres_storage/Cargo.toml

# USER root
# RUN mv $INDYSDK_PATH/libnullpay/target/release/libnullpay.so /usr/lib
# RUN mv $INDYSDK_PATH/experimental/plugins/postgres_storage/target/release/libindystrgpostgres.so /usr/lib

RUN rm -rf indy-sdk
 
# USER indy
