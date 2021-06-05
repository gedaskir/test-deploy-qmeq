#!/bin/bash
set -e -x

# Choose the directory containing the latest version of GCC
# as indicated by the highest number suffixed to
# the filepath of the package directory

echo "opt"
ls /usr/local/opt/

echo "local/bin"
ls /usr/local/bin/

echo "bin"
ls /usr/bin/

gcc --version

/usr/local/bin/gcc-10 --version

ln -sf /usr/local/bin/gcc-10 /usr/local/bin/gcc

gcc --version