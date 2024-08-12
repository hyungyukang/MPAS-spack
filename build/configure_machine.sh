#!/bin/sh

# Checklist by users
#   1. envs/envs_*.sh
#   2. mpas_target - MPAS-Model/Makefile
#   3. job_scripts/job_*.sh

# work directory
wdir=`pwd`

# =========================================================================
# Machine setup 
# =========================================================================

# HPC11 : GNU ----------------------------------------
machine=HPC11
compiler=GNU
batch_command=sbatch

# Frontier: GNU | Cray -------------------------------
#machine=Frontier
#compiler=GNU # Or Cray
#batch_command=sbatch

#-----------------------------------------------------

env_config=${wdir}/envs/envs_${machine}_${compiler}.sh
job_script=${wdir}/job_scripts/job_${machine}.sh

# =========================================================================

source $env_config

if [ -n "$NETCDF_DIR" ]; then
   NETCDF=$NETCDF_DIR
   NETCDFF=$NETCDF_DIR
fi
export NETCDF=$NETCDF_DIR
export NETCDFF=$NETCDF_DIR

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
