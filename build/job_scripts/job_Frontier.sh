#!/bin/bash
#SBATCH -A CLI115
#SBATCH -J MPASRUN
#SBATCH -N 1
#SBATCH -t 0:30:00
#SBATCH -q debug
#SBATCH --exclusive

source ./env.sh
echo $PIO
srun -n 56 -N 1 ./mpas_atmosphere -s streams.atmosphere -n namelist.atmosphere
