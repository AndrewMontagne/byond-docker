FROM debian:stable
RUN dpkg --add-architecture i386
RUN apt-get update
RUN (DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip nano wget procps rsync git curl)
RUN (DEBIAN_FRONTEND=noninteractive apt-get install -y g++-multilib gcc-multilib cmake make libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g-dev:i386 libssl-dev:i386 pkg-config:i386)
RUN pip3 install requests
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup override add stable-i686-unknown-linux-gnu

# BYOND
COPY get-byond.py /get-byond.py
RUN python3 /get-byond.py && rm /get-byond.py
RUN chmod +x /byond/bin/*
RUN ln -s /byond/bin/DreamMaker /usr/bin/DreamMaker && ln -s /byond/bin/DreamDaemon /usr/bin/DreamDaemon
COPY bashrc /root/.bashrc

# inode64 (fix for WSL)
COPY inode64 /root/inode64
RUN cd ~/inode64 && ./build.sh

# extools
RUN cd /tmp && git clone https://github.com/MCHSL/extools.git
RUN cd /tmp/extools/byond-extools && cmake . && make
RUN mkdir /root/.byond && mkdir /root/.byond/bin
RUN mv /tmp/extools/byond-extools/libbyond-extools.so /root/.byond/bin/byond-extools
RUN mv /tmp/extools/byond-extools/src/dm/socket.dm /byond/lib/socket.dm
RUN mv /tmp/extools/byond-extools/src/dm/_extools_api.dm /byond/lib/_extools_api.dm
RUN rm -rf /tmp/extools

# rust-g
RUN cd /tmp && git clone https://github.com/tgstation/rust-g.git
RUN cd /tmp/rust-g && cargo build --release --features dmi,noise,file,git,hash,log,url,http,sql
RUN mv /tmp/rust-g/target/release/librust_g.so /root/.byond/bin/librust_g.so
RUN mv /tmp/rust-g/target/rust_g.dm /byond/lib/rust_g.dm
RUN rm -rf /tmp/rust-g

COPY tools/DreamChecker /usr/bin/DreamChecker
COPY env.sh /byond/env.sh