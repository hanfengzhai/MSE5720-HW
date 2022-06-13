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

eta="0.497"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.506 0.506 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.498"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.504 0.504 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.499"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.502 0.502 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.500"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.500 0.500 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.501"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.498 0.498 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.502"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.496 0.496 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


eta="0.503"
cat > Si_tetra.cell_$eta.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si_elastic_tetra',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 celldm(1)=10.26d0,
 nat=2,
 ntyp=1,
 ecutwfc=50,
 ecutrho=600,
 occupations = 'fixed',
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
  10 10 10 0 0 0

CELL_PARAMETERS alat 
-$eta 0.d0 $eta
0.d0 $eta $eta
-0.494 0.494 0.d0
EOF

pw.x < Si_tetra.cell_$eta.in > Si_tetra.cell_$eta.out # Run the executable named pw.x 


done