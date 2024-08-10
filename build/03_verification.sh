#!/bin/sh

# Checklist by users
#   1. set_machine.sh
#   2. machine_envs/envs_*.sh
#     - mpas_target in MPAS-Model/Makefile
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

source ./set_machine.sh

# =========================================================================
# Compile the verification code
# =========================================================================

cd $verif_dir

# Link MPAS-Test output
ln -fs $run_dir/outputs/history.2022-07-20_18.00.00.nc ./

$FC -o verify.exe verify.f90 -lnetcdf
./verify.exe


#   if 
#      make $mpas_target CORE=atmosphere &> $log_mpas
#   then
#      echo "   [make $mpas_target CORE=atmosphere] completed successfully."
#   else
#      echo "   [make $mpas_target CORE=atmosphere] error: log = `pwd`/$log_mpas"
#      exit 1
#   fi
