#!/bin/sh
# =========================================================================
# Run a test case
# =========================================================================

# work directory
wdir=`pwd`

# =========================================================================
# Machine setup
# =========================================================================

source ./configure_machine.sh

# =========================================================================
# Run =====================================================================
# =========================================================================

# Building Thompson cloud microphysics scheme
if [ ! -f "$src_mpas/src/core_atmosphere/physics/physics_wrf/files/MP_THOMPSON_QRacrQG_DATA.DBL" ]; then
   cd $build_mpas/bin
   ./mpas_atmosphere_build_tables
   cp MP_THOM* $src_mpas/src/core_atmosphere/physics/physics_wrf/files/
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
ln -fs $src_mpas/src/core_atmosphere/physics/physics_wrf/files/* ./

# Submit a job
log_job=submit_job.log
jscript=`basename $job_script`

if 
   $batch_command $job_script &> $log_job
then
   echo "   [$batch_command $jscript] completed successfully in $run_dir"
else
   echo "   [$batch_command $jscript] error: log = `pwd`/$log_job"
fi
