#!/bin/sh

# =========================================================================
# Installation choose 
# =========================================================================
install_pio=true
install_mpas_init=true
install_mpas_model=true


# =========================================================================
# Machine setup 
# =========================================================================

# -------------------------------------------------------------------------
# Cray-GNU
# -------------------------------------------------------------------------

# MPAS-Model compilation target (can be found in MPAS-Model/Makefile)
mpas_target=gnu-nersc

# Module load 
module purge
module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module load cray-parallel-netcdf
#module load craype-x86-rome
#module load xpmem/2.8.2-1.0_3.9__g84a27a5.shasta
#module load slurm
#module load cray-pmi/6.1.13
#module load cmake
#echo $NETCDF_DIR

cc_comp=cc
cxx_comp=CC
fc_comp=ftn

# =========================================================================

if [ -n "$NETCDF_DIR" ]; then
   export NETCDF=$NETCDF_DIR
fi


# =========================================================================
# Directory setup =========================================================
# =========================================================================

# work directory
wdir=`pwd`

# PIO directory
src_pio=${wdir}/../ParallelIO
prefix_pio=${wdir}/ParallelIO

# CMake Fortran utils directory
src_fcutil=${wdir}/../CMake_Fortran_utils

# genf90 directory
src_genf90=${src_pio}/scripts

# MPAS-Model directory
src_mpas=${wdir}/../MPAS-Model


#------------------------------------------------------------
# Install ParallelIO 
#------------------------------------------------------------
if [ "$install_pio" = true ] ; then

if [ -d "$prefix_pio" ]; then
   rm -rf $prefix_pio 
fi

echo $prefix_pio
mkdir -p ${prefix_pio}/build
cd ${prefix_pio}/build
cwd=`pwd`

echo $src_fcutil
CC=$cc_comp CXX=$cxx_comp FC=$fc_comp cmake -DCMAKE_INSTALL_PREFIX=${prefix_pio} \
                                            -DNetCDF_PATH=${NETCDF} \
                                            -DNetCDF_C_PATH=${NETCDF} \
                                            -DNetCDF_Fortran_PATH=${NETCDF} \
                                            -DPnetCDF_PATH=${PNETCDF_DIR} \
                                            -DUSER_CMAKE_MODULE_PATH=${src_fcutil} \
                                            -DGENF90_PATH=${src_genf90} \
                                            $src_pio
make
make install

fi

#------------------------------------------------------------
# Install MPAS-Model (init_atmosphere & atmosphere)
#------------------------------------------------------------

export PIO=$prefix_pio
export NETCDFF=${NETCDF}

# Install MPAS-Model CORE=init_atmosphere
if [ "$install_mpas_init" = true ] ; then
  cd $src_mpas
  make clean CORE=init_atmosphere
  make $mpas_target CORE=init_atmosphere
fi

# Install MPAS-Model CORE=atmosphere
if [ "$install_mpas_model" = true ] ; then
  cd $src_mpas
  make clean CORE=atmosphere
  make $mpas_target CORE=atmosphere
fi
