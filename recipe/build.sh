#!/bin/bash
set -eu
exit 1
export EXTRA_CXXFLAGS="${CXXFLAGS} -std=c++17 -mmacosx-version-min=10.14"

# Enabling jemalloc does not work on OSX with the following error message:
# "error: unknown attribute 'je_malloc' ignored"
if [[ "${target_platform}" == osx-* ]]; then
  export WITH_JEMALLOC="OFF"
else
  export WITH_JEMALLOC="ON"
fi

### Create Makefiles
cmake ${CMAKE_ARGS} -GNinja \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_BUILD_TYPE=Release \
      -DFAIL_ON_WARNINGS=ON \
      -DPORTABLE=ON \
      -DUSE_RTTI=ON \
      -DWITH_BENCHMARK_TOOLS:BOOL=OFF \
      -DWITH_GFLAGS=ON \
      -DWITH_JEMALLOC=${WITH_JEMALLOC} \
      -DWITH_LZ4=ON \
      -DWITH_SNAPPY=ON \
      -DWITH_TESTS=OFF \
      -DWITH_TOOLS=OFF \
      -DWITH_ZLIB=ON \
      -DWITH_ZSTD=ON \
      -WITH_BZ2=ON \
      -S src \
      -B build

### Build
cmake  --build build -- -j${CPU_COUNT}

### Install
cmake --build build -- install

### Checking requires a recompile with DEBUG enabled
# cmake --build build -- check

### Copy the tools to $PREFIX/bin
# TODO: I someone needs the tools, please open a PR/issue.
# cp build/tools/{ldb,rocksdb_{dump,undump},sst_dump} $PREFIX/bin
