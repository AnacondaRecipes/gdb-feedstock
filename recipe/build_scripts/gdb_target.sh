#!/bin/bash

set -e

. ${RECIPE_DIR}/build_scripts/build_env.sh

rm -rf "${WDIR}/build/gdb-cross"
mkdir -p "${WDIR}/build/gdb-cross"
pushd "${WDIR}/build/gdb-cross"

    export ac_cv_func_strncmp_works=yes

    export CONFIG_SHELL="/bin/bash"
    export SHELL="/bin/bash" 

    mkdir -p "${PREFIX}"/etc

    echo '
python
import gdb
import sys
import os
def setup_python(event):
    import libpython
gdb.events.new_objfile.connect(setup_python)
end
' >> "$PREFIX/etc/gdbinit"

    CC_FOR_BUILD="${HOST}-gcc"                                             \
    CPP="${CFG_TARGET}-cpp"                                                \
    CC="${CFG_TARGET}-gcc"                                                 \
    CXX="${CFG_TARGET}-g++"                                                \
    LD="${CFG_TARGET}-ld"                                                  \
    CFLAGS="${ARCH_CFLAG}"                                                 \
    CXXFLAGS="${ARCH_CFLAG}"                                               \
    LDFLAGS="${HOST_LDFLAG} ${ARCH_LDFLAG} -L${BUILD_PREFIX}/lib"            \
    bash "${WDIR}/gdb/configure"                                           \
        --build=${HOST}                                                    \
        --host=${CFG_TARGET}                                               \
        --target=${CFG_TARGET}                                             \
        --prefix=${PREFIX}                                         \
        --disable-werror                                                   \
        --without-uiout                                                    \
        --disable-gdbtk                                                    \
        --without-x                                                        \
        --disable-sim                                                      \
        --with-system-gdbinit="$PREFIX/etc/gdbinit" \
        --without-included-gettext                                         \
        --without-develop                                                  \
        --sysconfdir=/etc                                                  \
        --localstatedir=/var                                               \
        --program-prefix=                                                  \
        --disable-gdbserver                                                \
        --with-curses                                                      \
        --with-expat                                                       \
        --without-libexpat-prefix                                          \
        --enable-64bit-bfd                                                 \
        --disable-multilib                                                 \
        --disable-binutils                                                 \
        --disable-ld                                                       \
        --disable-gas                                                      \
        --enable-threads                                                   \
        --disable-nls                                                      \
        --disable-inprocess-agent                                          \
        --with-python=${PYTHON}

    # --with-python=$PYTHON ...
    echo "Building gdb ..."
    make

    echo "Installing gdb ..."

    make DESTDIR=${WDIR}/gcc_built/${CFG_TARGET}/debug-root install

    unset ac_cv_func_strncmp_works

popd

