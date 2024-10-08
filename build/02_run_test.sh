#!/bin/sh
# =========================================================================
# Run a test case
# =========================================================================

# work directory
wdir=`pwd`

# =========================================================================
# Machine setup
# =========================================================================

source ./00_configure_machine.sh

# =========================================================================
# Run =====================================================================
# =========================================================================

# Building Thompson cloud microphysics scheme

cd $build_mpas/bin
if [[ "$machine" == "HPC11" ]]; then
   if [ ! -f "$src_mpas/src/core_atmosphere/physics/physics_wrf/files/MP_THOMPSON_QRacrQG_DATA.DBL" ]; then
      echo "   "
      echo " This is done only once, unless MPAS-Model is downloaded again."
      ./mpas_atmosphere_build_tables
      cp MP_THOM* $src_mpas/src/core_atmosphere/physics/physics_wrf/files/
   fi
else
   if [ ! -f "$build_mpas/_deps/mpas_data-src/atmosphere/physics_wrf/files/MP_THOMPSON_QRacrQG_DATA.DBL" ]; then
      echo "   "
      echo " This is done only once, unless MPAS-Model is downloaded again."
      ./mpas_atmosphere_build_tables
      cp MP_THOM* $build_mpas/_deps/mpas_data-src/atmosphere/physics_wrf/files
   fi
fi


# Enter run dir
cd $run_dir

# Copy job script & env
cp $job_script ./
cp $env_config ./env.sh
echo 'PIO='$PIO >> env.sh
source ./env.sh

# Link MPAS executable
ln -fs $build_mpas/bin/mpas_atmosphere ./

# Link MPAS physics tables
if [[ "$machine" == "HPC11" ]]; then
   ln -fs $src_mpas/src/core_atmosphere/physics/physics_wrf/files/* ./
else
   ln -fs $build_mpas/_deps/mpas_data-src/atmosphere/physics_wrf/files/* ./
fi

# Submit a job
log_job=submit_job.log
jscript=`basename $job_script`

if 
   $batch_command $job_script &> $log_job
then
   echo "   [$batch_command $jscript] Job is submitted successfully in $run_dir:"
   tail $log_job
   echo "   Once the job is done, move to next step."
else
   echo "   [$batch_command $jscript] error: log = `pwd`/$log_job"
fi
