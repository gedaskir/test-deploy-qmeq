#!/bin/bash
set -e -x

# Different Python versions separated by space
VERS=("3.6" "3.7" "3.8" "3.9")
len=${#VERS[@]}

# Links to different Python versions for MacOS
URLS=("https://www.python.org/ftp/python/3.6.8/python-3.6.8-macosx10.9.pkg",
      "https://www.python.org/ftp/python/3.7.9/python-3.7.9-macosx10.9.pkg",
      "https://www.python.org/ftp/python/3.8.10/python-3.8.10-macosx10.9.pkg",
      "https://www.python.org/ftp/python/3.9.5/python-3.9.5-macosx10.9.pkg")

PYPATH="/Library/Frameworks/Python.framework/Versions/"

for (( i=0; i<${len}; i++ )); do
    echo ${VERS[$i]}
    echo ${URLS[$i]}
    PNAME="/tmp/Python-${VERS[$i]}.pkg"
    curl -L -o $PNAME ${URLS[$i]}
    sudo installer -pkg $PNAME -target /
    #
    PYBIN="${PYPATH}/${VERS[$i]}/bin"
    sudo ln -sf "${PYBIN}/python${VERS[$i]}" "${PYBIN}/python"
    sudo ln -sf "${PYBIN}/pip${VERS[$i]}" "${PYBIN}/pip"
done

# Compile wheels and put them into mywheels/
for PYBIN in ${VERS[@]}; do
    PYBIN="${PYPATH}/${PYBIN}/bin"
    "${PYBIN}/pip" install -r scripts/requirements.txt
    "${PYBIN}/python" setup.py bdist_wheel -d mywheels
    "${PYBIN}/python" clean.py
done

# Install packages and test
mv mywheels dist
for PYBIN in ${VERS[@]}; do
    PYBIN="${PYPATH}/${PYBIN}/bin"
    "${PYBIN}/pip" install qmeq --no-index -f dist
    "${PYBIN}/pytest" --pyargs qmeq
done
