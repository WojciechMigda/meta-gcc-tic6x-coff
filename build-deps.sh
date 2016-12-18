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
export TARGET=tic6x-none-coff

function build_gmp {
  mkdir .work-gmp
  pushd .work-gmp

  PKG_VER=6.1.2
  PKG_BASE=gmp-${PKG_VER}
  PKG_FILE=${PKG_BASE}.tar.bz2

  wget -c https://gmplib.org/download/gmp/${PKG_FILE}
  tar xjf ${PKG_FILE}

  ln -sf ${PKG_BASE} src

  mkdir .build
  pushd .build

  ../src/configure --prefix=${PREFIX} && make -j && make install
  # make check

  popd

  popd
}

function build_mpfr {
  mkdir .work-mpfr
  pushd .work-mpfr

  PKG_VER=3.1.5
  PKG_BASE=mpfr-${PKG_VER}
  PKG_FILE=${PKG_BASE}.tar.bz2

  wget -c http://www.mpfr.org/mpfr-current/${PKG_FILE}
  tar xjf ${PKG_FILE}

  ln -sf ${PKG_BASE} src

  mkdir .build
  pushd .build

  ../src/configure --prefix=${PREFIX} --with-gmp=${PREFIX} && make -j && make install

  popd

  popd
}

function build_mpc {
  mkdir .work-mpc
  pushd .work-mpc

  PKG_VER=1.0.3
  PKG_BASE=mpc-${PKG_VER}
  PKG_FILE=${PKG_BASE}.tar.gz

  wget -c ftp://ftp.gnu.org/gnu/mpc/${PKG_FILE}
  tar xzf ${PKG_FILE}

  ln -sf ${PKG_BASE} src

  mkdir .build
  pushd .build

  ../src/configure --prefix=${PREFIX} --with-gmp=${PREFIX} --with-mpfr=${PREFIX} && make -j && make install

  popd

  popd
}

function build_isl {
  mkdir .work-isl
  pushd .work-isl

  PKG_VER=0.14
  PKG_BASE=isl-${PKG_VER}
  PKG_FILE=${PKG_BASE}.tar.bz2

  wget -c http://isl.gforge.inria.fr/${PKG_FILE}
  tar xjf ${PKG_FILE}

  ln -sf ${PKG_BASE} src

  mkdir .build
  pushd .build

  ../src/configure --prefix=${PREFIX} --with-gmp-prefix=${PREFIX} && make -j && make install

  popd

  popd
}

function build_cloog {
  mkdir .work-cloog
  pushd .work-cloog

  PKG_VER=0.18.4
  PKG_BASE=cloog-${PKG_VER}
  PKG_FILE=${PKG_BASE}.tar.gz

  wget -c http://www.bastoul.net/cloog/pages/download/${PKG_FILE}
  tar xzf ${PKG_FILE}
  ln -sf ${PKG_BASE} src

  mkdir .build
  pushd .build

  ../src/configure --prefix=${PREFIX} --with-gmp-prefix=${PREFIX} && make -j && make install

  popd

  popd
}


build_gmp && \
build_mpfr && \
build_mpc && \
#

exit 0
