#!/bin/bash
#SBATCH -A CLI115
#SBATCH -J MPASRUN
#SBATCH -N 1
#SBATCH -t 0:30:00
#SBATCH -q debug
#SBATCH --exclusive

source ./env.sh
echo $PIO
srun -n 128 -N 1 ./atmosphere_model -s streams.atmosphere -n namelist.atmosphere
