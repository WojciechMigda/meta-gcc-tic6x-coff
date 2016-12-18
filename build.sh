#!/bin/bash

function script_dir {
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  done
  echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}


export PREFIX=$(script_dir)/.local
export TARGET=tic6x-none-elf


function build_gcc {
  mkdir .build-gcc
  pushd .build-gcc

  ../gcc-tic6x-coff/configure --target=${TARGET} --prefix=${PREFIX} --disable-nls --enable-languages=c,c++ --without-headers \
    --with-gmp=${PREFIX} --with-mpfr=${PREFIX} --with-mpc=${PREFIX} \
    && make -j 4 all-gcc \
    && make -j 4 install-gcc \
    #&& make -j all-target-libgcc \
    #&& make -j install-target-libgcc

  popd
}

build_gcc && \
#

exit 0
