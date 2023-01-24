echo on

set "GFLAGS_LIB_RELEASE=%LIBRARY_PREFIX%\lib\gflags.lib"
set "SNAPPY_LIB_RELEASE=%LIBRARY_PREFIX%\lib\snappy.lib"
set "ZLIB_LIB_RELEASE=%LIBRARY_PREFIX%\lib\zlib.lib"
set "LZ4_LIB_RELEASE=%LIBRARY_PREFIX%\lib\liblz4.lib"
set "ZSTD_LIB_RELEASE=%LIBRARY_PREFIX%\lib\zstd.lib"

echo Running CMake...
cmake -GNinja ^
      -DROCKSDB_INSTALL_ON_WINDOWS=ON ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DFAIL_ON_WARNINGS=ON ^
      -DPORTABLE=ON ^
      -DUSE_RTTI=ON ^
      -DWITH_BENCHMARK_TOOLS:BOOL=OFF ^
      -DWITH_GFLAGS=ON ^
      -DWITH_LZ4=ON ^
      -DWITH_SNAPPY=ON ^
      -DWITH_TESTS=OFF ^
      -DWITH_TOOLS=OFF ^
      -DWITH_ZLIB=ON ^
      -DWITH_ZSTD=ON ^
      -WITH_BZ2=ON ^
      -WITH_JEMALLOC=OFF ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -S src ^
      -B build
if errorlevel 1 exit 1

echo Running CMake build...
cmake --build build
if errorlevel 1 exit 1

echo Running CMake install...
cmake --install build
if errorlevel 1 exit 1
