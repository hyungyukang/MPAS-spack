#!/bin/bash
#SBATCH -A NWP501
#SBATCH -J MPASRUN
#SBATCH -N 1
#SBATCH -t 2:00:00
#SBATCH --exclusive
#SBATCH -q collaboration
#SBATCH --cluster-constraint=blue

source ./env.sh
echo $PIO
srun -n 128 -N 1 ./mpas_atmosphere -s streams.atmosphere -n namelist.atmosphere
