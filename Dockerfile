FROM debian:stable
RUN dpkg --add-architecture i386
RUN apt-get update
RUN (DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip nano wget procps rsync gcc-multilib libc6:i386 libncurses5:i386 libstdc++6:i386)
RUN pip3 install requests
COPY get-byond.py /get-byond.py
RUN python3 /get-byond.py && rm /get-byond.py
RUN chmod +x /byond/bin/*
RUN ln -s /byond/bin/DreamMaker /usr/bin/DreamMaker && ln -s /byond/bin/DreamDaemon /usr/bin/DreamDaemon
COPY bashrc /root/.bashrc
COPY inode64 /root/inode64
RUN cd ~/inode64 && ./build.sh
RUN mkdir /root/.byond && mkdir /root/.byond/bin
COPY tools/libbyond-extools.so /root/.byond/bin/libbyond-extools.so
COPY tools/DreamChecker /usr/bin/DreamChecker