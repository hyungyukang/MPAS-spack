#!/bin/sh

# Checklist by users
#   1. 00_configure_machine.sh
#   2. machine_envs/envs_*.sh
#   3. job_scripts/job_*.sh

# Required library
#   - NetCDF
#   - Parallel-NetCDF
#   - ParallelIO

# work directory
wdir=`pwd`

# =========================================================================
# Verifications : Computing L2 error norm (Test VS Ref)
# =========================================================================

verif_dir=$wdir/verification

# =========================================================================
# Machine setup
# =========================================================================

source ./00_configure_machine.sh

# =========================================================================
# Compile the verification code
# =========================================================================

cd $verif_dir

if [ -f "$run_dir/outputs/history.2022-07-20_18.00.00.nc" ]; then
   # Link MPAS-Test output
   ln -fs $run_dir/outputs/history.2022-07-20_18.00.00.nc ./
   
   $FC -o verify.exe verify.f90 -lnetcdf
   ./verify.exe
else
   echo "   "
   echo " Output file does not exist: "
   echo "      $run_dir/outputs/history.2022-07-20_18.00.00.nc"
   echo "   "
   echo " Please check 'log.atmosphere...' in the test directory  "
   echo "      $run_dir"
fi



