#!/bin/bash

set -ex

_builddir="_build${PY_VER}"
mkdir -pv ${_builddir}
cd ${_builddir}

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DBUILD_TESTING:BOOL=no \
	-DCMAKE_BUILD_TYPE:STRING=Release \
	-DCMAKE_OSX_ARCHITECTURES:STRING="${OSX_ARCH}" \
	-DCMAKE_POLICY_VERSION_MINIMUM:STRING=3.5 \
	-DENABLE_SWIG_PYTHON2:BOOL=no \
	-DENABLE_SWIG_PYTHON3:BOOL=yes \
	-DPYTHON3_EXECUTABLE:FILE="${PYTHON}" \
	-DPYTHON3_VERSION:STRING=${PY_VER} \
	-DSWIG_EXECUTABLE:FILE="${BUILD_PREFIX}/bin/swig" \
;

# override the PYTHON3_LIBRARIES cache variable to stop
# attempting to link against the static libpython library
if [[ "${target_platform}" == "linux"* ]]; then
	cmake -DPYTHON3_LIBRARIES="" ${SRC_DIR}
fi

# build
cmake --build python --parallel ${CPU_COUNT} --verbose

# check
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
	ctest --parallel ${CPU_COUNT} --verbose
fi

# install
cmake --build python --parallel ${CPU_COUNT} --verbose --target install
