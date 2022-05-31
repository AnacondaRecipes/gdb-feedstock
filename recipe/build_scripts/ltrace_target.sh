#!/bin/bash

set -e

. ${RECIPE_DIR}/build_scripts/build_env.sh

# under construction ... until done disabled for arm
if [ "${CFG_ARCH}" = "arm" ]; then
  exit 0
fi

rm -rf "${WDIR}/build/ltrace-target"
mkdir -p "${WDIR}/build/ltrace-target"
pushd "${WDIR}/build/ltrace-target"
    cp -r "${WDIR}"/ltrace/* .

    # fixes a quirk in makefile, which uses cpu part of triplet
    # to determine subfolder name ...
    pushd "sysdeps/linux-gnu"
    ln -s ppc powerpc64le
    popd

    CONFIG_SHELL="/bin/bash"   \
    LDFLAGS="${TARGET_LDFLAG}" \
    bash ./configure           \
        --build=${HOST}        \
        --host=${CFG_TARGET}   \
        --prefix=/usr          \
        --with-gnu-ld

    echo "Building ltrace ..."
    make

    echo "Installing ltrace ..."
    make DESTDIR="${WDIR}/gcc_built/${CFG_TARGET}/debug-root" install

popd

