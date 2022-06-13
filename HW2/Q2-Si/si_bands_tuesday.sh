#!/bin/bash
#SBATCH -J Si        # Job Name
#SBATCH -o Si.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 10            # Requests number of tasks, in multiples of 64
#SBATCH -p development   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 00:30:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

cat > Si.cell_1.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.497d0 0.d0 0.497d0
0.d0 0.497d0 0.497d0
-0.497d0 0.497d0 0.d0
EOF

pw.x < Si.cell_1.in > Si.cell_1.out # Run the executable named pw.x 

# ==================================

cat > Si.cell_2.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.498d0 0.d0 0.498d0
0.d0 0.498d0 0.498d0
-0.498d0 0.498d0 0.d0
EOF

pw.x < Si.cell_2.in > Si.cell_2.out # Run the executable named pw.x 

# ===================================

cat > Si.cell_3.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.499d0 0.d0 0.499d0
0.d0 0.499d0 0.499d0
-0.499d0 0.499d0 0.d0
EOF

pw.x < Si.cell_3.in > Si.cell_3.out # Run the executable named pw.x 

# ===================================

cat > Si.cell_4.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.500d0 0.d0 0.500d0
0.d0 0.500d0 0.500d0
-0.500d0 0.500d0 0.d0
EOF

pw.x < Si.cell_4.in > Si.cell_4.out # Run the executable named pw.x 

# ==================================

cat > Si.cell_5.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.501d0 0.d0 0.501d0
0.d0 0.501d0 0.501d0
-0.501d0 0.501d0 0.d0
EOF

pw.x < Si.cell_5.in > Si.cell_5.out # Run the executable named pw.x 

# ====================================

cat > Si.cell_6.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.502d0 0.d0 0.502d0
0.d0 0.502d0 0.502d0
-0.502d0 0.502d0 0.d0
EOF

pw.x < Si.cell_6.in > Si.cell_6.out # Run the executable named pw.x 

# ==================================

cat > Si.cell_7.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.1941d0,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=30,
 ecutrho=300,
 occupations = 'fixed',
 use_all_frac = .true.,
/
&ELECTRONS
 conv_thr = 1.0D-8,
 mixing_mode = 'plain',
 mixing_beta = 0.7d0,
 diagonalization = 'cg',
/
&IONS
 ion_dynamics='bfgs',
/
&CELL
 cell_dynamics = 'bfgs',
 press=0.1d0,
/
ATOMIC_SPECIES
Si 28.0855d0 Si_LDA.UPF

ATOMIC_POSITIONS crystal
Si 0.d0 0.d0 0.d0
Si 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  8 8 8 0 0 0

CELL_PARAMETERS alat 
-0.503d0 0.d0 0.503d0
0.d0 0.503d0 0.503d0
-0.503d0 0.503d0 0.d0
EOF

pw.x < Si.cell_7.in > Si.cell_7.out # Run the executable named pw.x 

done
