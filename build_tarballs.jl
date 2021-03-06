using BinaryBuilder

# Collection of sources required to build openspecfun
sources = [
    "https://github.com/JuliaLang/openspecfun/archive/v0.5.3.tar.gz" =>
    "1505c7a45f9f39ffe18be36f7a985cb427873948281dbcd376a11c2cd15e41e7",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd openspecfun-*/

# It needs to be told it's on Windows
if [[ ${target} == *mingw* ]]; then
    OS=WINNT
    libdir=$prefix/bin
elif [[ ${target} == *darwin* ]]; then
    OS=Darwin
fi

# Build it
make OS=${OS} CC="$CC" CXX="$CXX" FC="$FC" -j${nproc}

# Install it
mkdir -p $libdir $prefix/include
mv libopenspecfun*.${dlext}* $libdir/
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = prefix -> [
    LibraryProduct(prefix, "libopenspecfun", :libopenspecfun)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libopenspecfun", sources, script, platforms, products, dependencies)
