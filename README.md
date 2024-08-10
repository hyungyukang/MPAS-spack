# MPAS-spack

## Collection of MPAS-Model and required libraries as submodules  

## Quick start (tested on Perlmutter and Frontier)

```
git clone git@github.com:hyungyukang/MPAS-spack.git
cd MPAS-spack
git submodule update --init --recursive
cd build

# Install PIO and MPAS-Atmosphere
./01_install.sh

# Run MPAS-Atmosphere test case
./02_run_test.sh

# Verify results at 48 h
./03_verification.sh
```

## User check list
1. build/set_machine.sh
2. build/envs/envs_*.sh
   - mpas_target in MPAS-Model/Makefile
3. build/job_scripts/job_*.sh

