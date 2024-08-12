# MPAS-spack
## MPAS-Atmosphere test suite
### Collection of MPAS-Model and required libraries as submodules to run a test case
The following are provided, except the model and library codes:
- Build scripts
- Job batch script
- Initial condition for a test case
- Reference output for verification  

## Quick start (tested on HPC11 and Frontier)

### User check list
1. Machine configuration: build/set_machine.sh
2. Machine environmental: build/envs/envs_<machine>_<compiler>.sh
   - mpas_target in MPAS-Model/Makefile
3. Job batch script: build/job_scripts/job_<machine>_<compiler>.sh

#### For a new machine, user must create system files below
1. Machine environmental: build/envs/envs_<machine>_<compiler>.sh
2. Job batch script: build/job_scripts/job_<machine>_<compiler>.sh
3. Check and choose appropriate mpas_target in MPAS-Model/Makefile
   - Users can create a customized target.

### Build, run, and verification

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


