#!/bin/bash
set -e -x

# Different Python versions separated by space
VERS=("cp36-cp36m" "cp37-cp37m" "cp38-cp38m" "cp39-cp39m")

# Compile wheels and put them into /io/mywheels/
cd /io
for PYBIN in ${VERS[@]}; do
    echo $PYBIN
    PYBIN="/opt/python/${PYBIN}/bin"
    "${PYBIN}/pip" install -r /io/scripts/requirements.txt
    "${PYBIN}/python" setup.py bdist_wheel -d mywheels
    "${PYBIN}/python" clean.py
done
cd ..

# Bundle external shared libraries into the wheels
# Move the audited wheels to /io/dist/
for whl in /io/mywheels/*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done

# Install packages and test
for PYBIN in ${VERS[@]}; do
    PYBIN="/opt/python/${PYBIN}/bin"
    "${PYBIN}/pip" install qmeq --no-index -f /io/dist/
    "${PYBIN}/pytest" --pyargs qmeq
done
