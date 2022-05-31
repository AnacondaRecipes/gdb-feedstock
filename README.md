# gcc_toolchain-feedstock

It contains build scripts and recipe for a specific gcc version.

Currently supported gcc version 11.2.0

Each version will live in branch 'main-gcc-<version>'.  On 'main' just the newest
version is available and needs to get branched as soon as an newer version exists.

The sources of this package can be found in gcc_toolchain-sources repository.  They
live there in brach 'gcc-<version>-<architeture>.  Eg for linux-64 gcc version 11.2.0
can be found in branch 'gcc-11.2-linux-64'.  Those file getting installed by the
script 'decompress.sh' found in recipe/ folder.

In recipe/ folder you can find additionally the recipe definition in meta.yaml, the
install scripts in recipe/install_scripts, which are used by the recipe.  There is
recipe/build_scripts/ folder, which contains all required scripts to build a full
featured toolchain (binutils, gcc, glibc, gdb, ltrace, strace, etc).

