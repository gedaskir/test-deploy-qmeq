#!/bin/bash
set -e -x

# Choose the directory containing the latest version of GCC
# as indicated by the highest number suffixed to
# the filepath of the package directory
print -v version /usr/local/opt/gcc@<->(n[-1])
version=${version#*@}
for file in /usr/local/opt/gcc@${version}/bin/*-${version}(*); do
    tail=${file:t}
    ln -sf ${file} /usr/local/bin/${tail%-*}
done

gcc --version
