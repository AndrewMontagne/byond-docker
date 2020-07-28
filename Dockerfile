FROM i386/debian:stable
RUN apt-get update
RUN (DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip nano wget)
RUN pip3 install requests
COPY get-byond.py /get-byond.py
RUN python3 /get-byond.py && rm /get-byond.py
RUN chmod +x /byond/bin/*
COPY bashrc /root/.bashrc
COPY inode64 /root/inode64
RUN cd ~/inode64 && ./build.sh && mv b32/inode64.so /lib/inode64.so
RUN mkdir /root/.byond && mkdir /root/.byond/bin
COPY extools/libbyond-extools.so /root/.byond/bin/libbyond-extools.so