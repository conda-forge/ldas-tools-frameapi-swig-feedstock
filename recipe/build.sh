#!/bin/bash

set -ex

mkdir -p _build
pushd _build

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo \
	-DENABLE_SWIG_PYTHON2:BOOL=no \
	-DENABLE_SWIG_PYTHON3:BOOL=no \
	-DSWIG_EXECUTABLE:FILE="${BUILD_PREFIX}/bin/swig" \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# check
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
	ctest --parallel ${CPU_COUNT} --verbose
fi

# install
cmake --build . --parallel ${CPU_COUNT} --verbose --target install
