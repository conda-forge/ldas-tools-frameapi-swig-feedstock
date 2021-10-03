#!/bin/bash

set -ex

_builddir="_build${PY_VER}"
mkdir -pv ${_builddir}
cd ${_builddir}

# get python options
if [ "${PY3K}" -eq 1 ]; then
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON2=no -DENABLE_SWIG_PYTHON3=yes -DPYTHON3_EXECUTABLE=${PYTHON}"
else
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON3=no -DENABLE_SWIG_PYTHON2=yes -DPYTHON2_EXECUTABLE=${PYTHON}"
fi

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DENABLE_SWIG_PYTHON2:BOOL=no \
	-DENABLE_SWIG_PYTHON3:BOOL=yes \
;

# build
cmake --build python --parallel ${CPU_COUNT} --verbose

# check
ctest --parallel ${CPU_COUNT} --verbose

# install
cmake --build python --parallel ${CPU_COUNT} --verbose --target install
