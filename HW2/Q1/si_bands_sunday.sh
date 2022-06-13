#!/bin/bash
#SBATCH -J Si        # Job Name
#SBATCH -o Si.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 10            # Requests number of tasks, in multiples of 64
#SBATCH -p development   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 00:30:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006
set -x   # Echo commands, use set echo with csh

PREFIX="Si"
PSEUDO_DIR="./"
INFILE="$PREFIX.in"
OUTFILE="$PREFIX.out"

cat > $INFILE << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='$PREFIX',
 pseudo_dir='$PSEUDO_DIR',
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

EOF

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

INFILE="$PREFIX.nscf.in"
OUTFILE="$PREFIX.nscf.out"

cat > $INFILE << EOF
&CONTROL
  calculation = 'nscf',
  restart_mode = 'from_scratch',
  prefix = 'silicon',
  pseudo_dir = './'
  verbosity = 'high'
/

&SYSTEM
  ibrav =  2,
  celldm(1) = 10.1941,
  nat =  2,
  ntyp = 1,
  ecutwfc = 30,
  ecutrho = 300,
  nbnd = 8,
  occupations='tetrahedra'
/

&ELECTRONS
  conv_thr = 1e-8,
  mixing_beta = 0.6
/

ATOMIC_SPECIES
  Si 28.086 Si_LDA.UPF

ATOMIC_POSITIONS (alat)
  Si 0.0d0 0.0d0 0.0d0
  Si 0.25d0 0.25d0 0.25d0

K_POINTS (automatic)
  12 12 12 0 0 0

EOF

pw.x < $INFILE > $OUTFILE


INFILE="$PREFIX.bands.in"
OUTFILE="$PREFIX.bands.out"

cat > $INFILE << EOF
# &CONTROL
#  calculation = 'bands',
#  restart_mode= 'from_scratch',
#  prefix='$PREFIX',
#  pseudo_dir='$PSEUDO_DIR',
# /
# &SYSTEM
#  ibrav=2,
#  celldm(1)=10.1941d0,
#  nat=2,
#  ntyp=1,
#  nbnd=8,
#  ecutwfc=30,
#  ecutrho = 300,
#  occupations = 'fixed',
#  use_all_frac = .true.,
# /
# &ELECTRONS
#  conv_thr = 1.0D-8,
#  mixing_mode = 'plain',
#  mixing_beta = 0.7d0,
#  diagonalization = 'cg',
# /
# &IONS
#  ion_dynamics='bfgs',
# /
# &CELL
#  cell_dynamics = 'bfgs',
#  press=0.1d0,
# /
# ATOMIC_SPECIES
# Si 28.0855d0 Si_LDA.UPF

# ATOMIC_POSITIONS (alat)
# Si 0.d0 0.d0 0.d0
# Si 0.25d0 0.25d0 0.25d0

# K_POINTS {crystal_b}
# 14
#  0.500000  0.000000  0.500000   ! X
#  0.500000  0.250000  0.750000   ! W
#  0.500000  0.250000  0.750000   ! W
#  0.500000  0.500000  0.500000   ! L
#  0.500000  0.500000  0.500000   ! L
#  0.000000  0.000000  0.000000   ! Gamma
#  0.000000  0.000000  0.000000   ! Gamma
#  0.500000  0.000000  0.500000   ! X
#  0.500000  0.500000  1.000000   ! X_1
#  0.375000  0.375000  0.750000   ! K
#  0.375000  0.375000  0.750000   ! K
#  0.125000  0.125000  0.250000   ! U
#  0.125000  0.125000  0.250000   ! U
#  0.000000  0.000000  0.000000   ! Gamma

&control
  calculation = 'bands',
  restart_mode = 'from_scratch',
  prefix='$PREFIX',
  pseudo_dir='$PSEUDO_DIR',
  verbosity = 'high'
/

&system
  ibrav =  2,
  celldm(1) = 10.1941d0,
  nat =  2,
  ntyp = 1,
  ecutwfc = 30,
  ecutrho = 300,
  nbnd = 8
 /

&electrons
  conv_thr = 1e-8,
  mixing_beta = 0.7
 /

ATOMIC_SPECIES
  Si 28.086  Si_LDA.UPF

ATOMIC_POSITIONS (alat)
  Si 0.00 0.00 0.00
  Si 0.25 0.25 0.25

K_POINTS {crystal_b}
5
  0.0000 0.5000 0.0000 20  !L
  0.0000 0.0000 0.0000 30  !G
  -0.500 0.0000 -0.500 10  !X
  -0.375 0.2500 -0.375 30  !U
  0.0000 0.0000 0.0000 20  !G

EOF

pw.x < $INFILE > $OUTFILE # Run the executable named pw.x

INFILE="$PREFIX.plot.in"
OUTFILE="$PREFIX.plot.out"

cat > $INFILE << EOF
&BANDS
 prefix='$PREFIX',
 filband="Si.bandsplot"
/

EOF

bands.x < $INFILE > $OUTFILE

INFILE="$PREFIX.dos.in"
OUTFILE="$PREFIX.dos.out"

cat > $INFILE << EOF
&DOS
 prefix='$PREFIX',
 fildos='$PREFIX.dos'
 Emin=-9, Emax=18, DeltaE=0.1
/
EOF

dos.x < $INFILE > $OUTFILE

INFILE="$PREFIX.pdos.in"
OUTFILE="$PREFIX.pdos.out"

cat > $INFILE << EOF
&PROJWFC
 prefix='$PREFIX',
 Emin=-9, Emax=18, DeltaE=0.1
 filpdos='$PREFIX.pdos',
 filproj='$PREFIX.proj'
/
EOF

projwfc.x < $INFILE > $OUTFILE


# rm *.igk *.wfc*
# rm -r *.save


