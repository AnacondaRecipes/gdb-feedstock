set -e -x

# CHOST=$(${SRC_DIR}/build/gcc-final/gcc/xgcc -dumpmachine)

curl -SL https://raw.githubusercontent.com/python/cpython/$PY_VER/Tools/gdb/libpython.py \
    > "$SP_DIR/libpython.py"

export PATH=${SRC_DIR}/compilers/bin:$PATH

# libtool wants to use ranlib that is here
# for psuedo-cross, depending on the build and host,
# build-gdb-native could be used (it will have been built
# with the newer GCC instead of the system one).
pushd ${SRC_DIR}/build/gdb-cross
  PATH=${SRC_DIR}/buildtools/bin:$PATH \
  make prefix=${PREFIX} install
  # Gets installed by binutils:
  rm ${PREFIX}/share/info/bfd.info
popd

    mkdir -p "${PREFIX}"/etc

    echo '
python
import gdb
import sys
import os
try:
  from libstdcxx.v6.printers import register_libstdcxx_printers
  register_libstdcxx_printers(gdb.current_objfile())
except:
  pass

def setup_python(event):
    import libpython
gdb.events.new_objfile.connect(setup_python)
end
' >> "${PREFIX}/etc/gdbinit"

set +x
# Strip executables, we may want to install to a different prefix
# and strip in there so that we do not change files that are not
# part of this package.
pushd ${PREFIX}
  _files=$(find . -type f)
  for _file in ${_files}; do
    _type="$( file "${_file}" | cut -d ' ' -f 2- )"
    case "${_type}" in
      *script*executable*)
      ;;
      *executable*)
        strip --strip-unneeded -v "${_file}" || :
      ;;
    esac
  done
popd

source ${RECIPE_DIR}/install_scripts/make_tool_links.sh
