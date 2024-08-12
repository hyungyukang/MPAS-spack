#!/bin/sh

# Checklist by users
#   1. configure_machine.sh
#   2. machine_envs/envs_*.sh
#     - mpas_target in MPAS-Model/Makefile
#   3. job_scripts/job_*.sh

# Required library
#   - NetCDF
#   - Parallel-NetCDF
#   - ParallelIO

# =========================================================================
# Test process choice
# =========================================================================

install_pio=true # ParallelIO installation
install_mpas=true # MPAS-Atmosphere installation
run_mpas_test=false # if false, user can run the test case separately by running 'run_test.sh'.

# work directory
wdir=`pwd`

# =========================================================================
# Machine setup
# =========================================================================

source ./configure_machine.sh

# =========================================================================
# Install & Run ===========================================================
# =========================================================================

#------------------------------------------------------------
# Install ParallelIO 
#------------------------------------------------------------
if [ "$install_pio" = true ] ; then

   log_pio=install_pio.log
   echo "--- Installing ParallelIO ---"
   
   if [ -d "$prefix_pio" ]; then
      rm -rf $prefix_pio 
   fi
   
   mkdir -p ${prefix_pio}/build
   cd ${prefix_pio}/build
   cwd=`pwd`
   
   #-------
   if
      CC=$CC CXX=$CXX FC=$FC cmake -DCMAKE_INSTALL_PREFIX=${prefix_pio} \
                                                  -DNetCDF_PATH=${NETCDF} \
                                                  -DNetCDF_C_PATH=${NETCDF} \
                                                  -DNetCDF_Fortran_PATH=${NETCDF} \
                                                  -DPnetCDF_PATH=${PNETCDF_DIR} \
                                                  -DUSER_CMAKE_MODULE_PATH=${src_fcutil} \
                                                  -DGENF90_PATH=${src_genf90} \
                                                  -DPIO_ENABLE_TIMING=OFF \
                                                  $src_pio &> $log_pio
   then
      echo "   [cmake] completed successfully."
   else
      echo "   [cmake] error: log = `pwd`/$log_pio"
      exit 1
   fi
   
   #-------
   if 
      make &>> $log_pio
   then 
      echo "   [make] completed successfully."
   else
      echo "   [make] error: log = `pwd`/$log_pio"
      exit 1
   fi
   
   #-------
   if 
      make install &>> $log_pio
   then
      echo "   [make install] completed successfully."
   else
      echo "   [make install] error: log = `pwd`/$log_pio"
      exit 1
   fi
   #-------

fi  # install_pio

#------------------------------------------------------------
# Install MPAS-Model
#------------------------------------------------------------

if [ "$install_mpas" = true ] ; then

   log_mpas=compile_mpas.log
   echo "--- Installing MPAS-Atmosphere (this will take several minutes.) ---"
 
   cd $src_mpas
   make clean CORE=atmosphere &> clean.log
   echo "   [make clean CORE=atmosphere] completed successfully."
 
   if 
      make $mpas_target CORE=atmosphere &> $log_mpas
   then
      echo "   [make $mpas_target CORE=atmosphere] completed successfully."
   else
      echo "   [make $mpas_target CORE=atmosphere] error: log = `pwd`/$log_mpas"
      exit 1
   fi

fi # install_mpas


# =========================================================================
# Run test ================================================================
# =========================================================================
if [ "$run_mpas_test" = true ] ; then

   echo "--- Submitting job ---"

   cd $wdir
   ./run_test.sh

fi # run_mpas_test
