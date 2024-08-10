#!/bin/sh

# MPAS-Model compilation target (can be found in MPAS-Model/Makefile)
mpas_target=gnu-nersc

# Module load 
module purge
module load PrgEnv-gnu
module load cray-hdf5-parallel
module load cray-netcdf-hdf5parallel
module load cray-parallel-netcdf
module swap cray-mpich cray-mpich-ucx
module load cray-ucx
module swap craype-network-ofi craype-network-ucx
module load craype-x86-rome
module load xpmem/2.8.2-1.0_3.9__g84a27a5.shasta
module load slurm
module load cray-pmi/6.1.13

CC=cc
CXX=CC
FC=ftn
