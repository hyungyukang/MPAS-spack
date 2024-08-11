# MPAS-spack

## Collection of MPAS-Model and required libraries as submodules  

## Quick start (tested on Perlmutter and Frontier)

```
git clone git@github.com:hyungyukang/MPAS-spack.git
cd MPAS-spack
git submodule update --init --recursive

# Download initial condition
cd MPAS-spack/MPAS-Test/init_files
wget -O x1.120km.init.2022072018.nc "https://www.dropbox.com/scl/fi/54bn1rroze5p1x0ng2270/x1.120km.init.2022072018.nc?rlkey=0b3tqvrzrpu00bsildpnj8d4w&st=1ftikfd1&dl=0"

# Build, run, verification
cd MPAS-spack/build

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

