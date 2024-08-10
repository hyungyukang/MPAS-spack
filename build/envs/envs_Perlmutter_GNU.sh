#!/bin/sh

# MPAS-Model compilation target (can be found in MPAS-Model/Makefile)
mpas_target=gnu-nersc

# Module load 
module purge
module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module load cray-parallel-netcdf
module load craype-x86-rome

CC=cc
CXX=CC
FC=ftn
