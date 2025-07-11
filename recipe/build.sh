#!/bin/bash
set -eu

# Set platform-specific flags
if [[ "${target_platform}" == linux-* ]]; then
  export CXXFLAGS="${CXXFLAGS} -std=c++17 -Wno-error=array-bounds -Wno-error=attributes"
else
  export CXXFLAGS="${CXXFLAGS} -std=c++17 -mmacosx-version-min=10.14"
fi

if [[ ! -z "${rocksdb_build_ext+x}" && "${rocksdb_build_ext}" == "jemalloc" ]]; then
    echo "Building with jemalloc"
    export WITH_JEMALLOC="ON"
else
    echo "Building without jemalloc"
    export WITH_JEMALLOC="OFF"
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
