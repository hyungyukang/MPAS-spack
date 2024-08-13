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

install_pio=false # ParallelIO installation
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
#------------------------------------------------------------
# Install ParallelIO 
#------------------------------------------------------------
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
   
   #------------------------------------------------
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
   #------------------------------------------------
   if 
      make &>> $log_pio
   then 
      echo "   [make] completed successfully."
   else
      echo "   [make] error: log = `pwd`/$log_pio"
      exit 1
   fi
   #------------------------------------------------
   if 
      make install &>> $log_pio
   then
      echo "   [make install] completed successfully."
   else
      echo "   [make install] error: log = `pwd`/$log_pio"
      exit 1
   fi
   #------------------------------------------------

fi  # install_pio

#------------------------------------------------------------
#------------------------------------------------------------
# Install MPAS-Model
#------------------------------------------------------------
#------------------------------------------------------------

if [ "$install_mpas" = true ] ; then

   log_mpas=compile_mpas.log
   echo "--- Installing MPAS-Atmosphere (this will take several minutes.) ---"

   #------------------------------------------------
   if [ -d "$build_mpas" ]; then
      rm -rf $build_mpas
   fi
   mkdir $build_mpas
   #------------------------------------------------
   if
      cd $build_mpas

      if [[ "$machine" == "HPC11" ]]; then   # HPC11 has a different cmake command.
         if [ ! -d "${src_mpas}/src/core_atmosphere/atmosphere" ]; then
            mkdir ${src_mpas}/src/core_atmosphere/atmosphere
            cd ${src_mpas}/src/core_atmosphere/atmosphere
            ln -fs ${src_mpas}/src/core_atmosphere/physics ./
         fi

         CC=$CC CXX=$CXX FC=$FC cmake -DCMAKE_INSTALL_PREFIX=${run_dir} \
                                      -DNetCDF_PATH=${NETCDF} \
                                      -DNetCDF_C_PATH=${NETCDF} \
                                      -DNetCDF_Fortran_PATH=${NETCDF} \
                                      -DPnetCDF_PREFIX=${PNETCDF_DIR} \
                                      -DPIO_PREFIX=${prefix_pio} \
                                      -DFETCHCONTENT_SOURCE_DIR_MPAS_DATA=${src_mpas}/src/core_atmosphere \
                                      -DFETCHCONTENT_UPDATES_DISCONNECTED=ON \
                                      -S $src_mpas \
                                      -B . &> $log_mpas

      else # machine

         CC=$CC CXX=$CXX FC=$FC cmake -DCMAKE_INSTALL_PREFIX=${run_dir} \
                                      -DNetCDF_PATH=${NETCDF} \
                                      -DNetCDF_C_PATH=${NETCDF} \
                                      -DNetCDF_Fortran_PATH=${NETCDF} \
                                      -DPnetCDF_PREFIX=${PNETCDF_DIR} \
                                      -DPIO_PREFIX=${prefix_pio} \
                                      -S $src_mpas \
                                      -B . &> $log_mpas

      fi # machine
   then
      echo "   [cmake] completed successfully."
   else
      echo "   [cmake] error: log = `pwd`/$log_mpas"
      exit 1
   fi
   #------------------------------------------------
   if
      make -j 4 &>> $log_mpas
   then
      echo "   [make] completed successfully."
   else
      echo "   [make] error: log = `pwd`/$log_mpas"
      exit 1
   fi
   #------------------------------------------------
   if
      make install &>> $log_mpas
   then
      echo "   [make install] completed successfully."
   else
      echo "   [make install] error: log = `pwd`/$log_mpas"
      exit 1
   fi
   #------------------------------------------------

fi # install_mpas

# =========================================================================
# Run test ================================================================
# =========================================================================
if [ "$run_mpas_test" = true ] ; then

   echo "--- Submitting job ---"

   cd $wdir
   ./run_test.sh

fi # run_mpas_test
