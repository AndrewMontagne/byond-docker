#!/bin/sh

# info for ld

cat > vers <<EOC
GLIBC_2.0 {
global:
readdir;
__fxstat;
__xstat;
__lxstat;
};
EOC

# build fixed stat for 32bit apps

gcc -c -fPIC -m32 -fno-stack-protector inode64.c
mkdir -p b32
ld -shared -melf_i386 --version-script vers -o b32/inode64.so inode64.o

# build empty lib that does nothing for 64bit apps

mkdir -p b64
echo "" | gcc -xc -fPIC -shared -o b64/inode64.so -

# ld will pickup 64b lib for 64bit apps and 32b lib with fixed stat for 32bit apps

cp b64/inode64.so /lib/x86_64-linux-gnu/inode64.so
cp b32/inode64.so /lib/i386-linux-gnu/inode64.so
cp b32/inode64.so /lib/inode64.so