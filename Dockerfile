FROM debian:stable-slim
RUN dpkg --add-architecture i386
RUN apt-get update
RUN (DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y python3 python3-requests rsync curl git git-lfs wget tree expect nano libssl-dev pkg-config)
RUN (DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y g++-multilib gcc-multilib cmake make libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g-dev:i386 libssl-dev:i386 pkg-config:i386)
RUN rm -rf /var/lib/apt/lists/*
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup override add stable-i686-unknown-linux-gnu
RUN rustup target add i686-unknown-linux-gnu
RUN rustup install 1.69.0
RUN rustup target add --toolchain 1.69.0 i686-unknown-linux-gnu

# BYOND
COPY get-byond.py /get-byond.py
RUN python3 /get-byond.py && rm /get-byond.py
RUN chmod +x /byond/bin/*
RUN ln -s /byond/bin/DreamMaker /usr/bin/DreamMaker && ln -s /byond/bin/DreamDaemon /usr/bin/DreamDaemon
COPY bashrc /root/.bashrc

# inode64 (fix for WSL)
COPY inode64 /root/inode64
RUN cd ~/inode64 && ./build.sh

# rust-g
RUN mkdir /root/.byond && mkdir /root/.byond/bin
RUN cd /tmp && git clone https://github.com/tgstation/rust-g.git
RUN cd /tmp/rust-g && cargo build --release --features dmi,noise,file,git,hash,log,url,http,sql
RUN mv /tmp/rust-g/target/release/librust_g.so /root/.byond/bin/librust_g.so
RUN mv /tmp/rust-g/target/rust_g.dm /byond/lib/rust_g.dm
RUN rm -rf /tmp/rust-g

COPY env.sh /byond/env.sh

# SpacemanDMM
RUN cd /tmp && git clone https://github.com/SpaceManiac/SpacemanDMM.git

RUN cd /tmp/SpacemanDMM && cargo build --release --bin dreamchecker
RUN cp /tmp/SpacemanDMM/target/release/dreamchecker /usr/bin/DreamChecker

RUN cd /tmp/SpacemanDMM && cargo build --release --bin dmm-tools
RUN cp /tmp/SpacemanDMM/target/release/dmm-tools /usr/bin/dmm-tools

RUN cd /tmp/SpacemanDMM && cargo build --release --bin dmdoc
RUN cp /tmp/SpacemanDMM/target/release/dmdoc /usr/bin/dmdoc

RUN cd /tmp/SpacemanDMM && cargo build --release --bin dm-langserver
RUN cp /tmp/SpacemanDMM/target/release/dm-langserver /usr/bin/dm-langserver

COPY dreamchecker.dm /byond/lib/dreamchecker.dm

# Auxtools

RUN cd /tmp && git clone https://github.com/willox/auxtools
#RUN cd /tmp/auxtools && git checkout 4f362a3b88220955945e53735b1d5be93abe83b2

ENV PKG_CONFIG_ALLOW_CROSS=1
RUN cd /tmp/auxtools && rustup run 1.69.0 cargo build --release --target i686-unknown-linux-gnu

RUN cp /tmp/auxtools/target/i686-unknown-linux-gnu/release/libdebug_server.so /root/.byond/bin/libdebug_server.so
COPY debug_server.dm /byond/lib/debug_server.dm

# Environment File
COPY env.sh /byond/env.sh

# Cleanup
RUN rustup self uninstall -y
RUN rm -rf /root/.cargo && rm -rf /root/.rustup && rm -rf /tmp/*
RUN (DEBIAN_FRONTEND=noninteractive apt-get remove -y g++-multilib gcc-multilib libncurses5:i386 zlib1g-dev:i386 pkg-config:i386 cmake python3-requests curl wget)
RUN (DEBIAN_FRONTEND=noninteractive apt-get autoremove -y)
RUN rm -rf /cache/* && rm -rf /root/.vscode-server/bin/*/extensions/*

# Tests
ADD tests /byond/tests