#!/bin/sh

# Checklist by users
#   1. envs/envs_*.sh
#   2. job_scripts/job_*.sh

# work directory
wdir=`pwd`

# =========================================================================
# Machine setup : User modification section
# =========================================================================

# HPC11 : GNU ----------------------------------------
machine=HPC11
compiler=GNU
batch_command=sbatch

# Frontier: GNU --------------------------------------
#machine=Frontier
#compiler=GNU
#batch_command=sbatch

# =========================================================================
# End of user modification section
# =========================================================================

env_config=${wdir}/envs/envs_${machine}_${compiler}.sh
job_script=${wdir}/job_scripts/job_${machine}.sh

#-----------------------------------------------------

# Source machine environmental config
source $env_config

if [ -n "$NETCDF_DIR" ]; then
   NETCDF=$NETCDF_DIR
   NETCDFF=$NETCDF_DIR
fi

# =========================================================================
# Directory setup =========================================================
# =========================================================================

# PIO directory
src_pio=${wdir}/../ParallelIO
prefix_pio=${wdir}/ParallelIO
PIO=$prefix_pio
export PIO=$prefix_pio

# CMake Fortran utils directory
src_fcutil=${wdir}/../CMake_Fortran_utils

# genf90 directory
src_genf90=${src_pio}/scripts

# MPAS-Model directory
src_mpas=${wdir}/../MPAS-Model

# MPAS-Test run directory
run_dir=${wdir}/../MPAS-Test
build_mpas=${wdir}/mpas-atmosphere
