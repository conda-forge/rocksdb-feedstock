#!/bin/bash
set -eu

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
      -DWITH_JEMALLOC=ON \
      -DWITH_LZ4=ON \
      -DWITH_SNAPPY=ON \
      -DWITH_TESTS=OFF \
      -DWITH_TOOLS=OFF \
      -DWITH_ZLIB=OFF \
      -DWITH_ZSTD=ON \
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
