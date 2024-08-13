#!/bin/sh

# Module load 
module purge
module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module load cray-parallel-netcdf
module load craype-x86-trento

CC=cc
CXX=CC
FC=ftn
