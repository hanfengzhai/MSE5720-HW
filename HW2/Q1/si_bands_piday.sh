#!/bin/bash
#SBATCH -J Si        # Job Name
#SBATCH -o Si.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 8            # Requests number of tasks, in multiples of 64
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
  20 20 20 0 0 0

EOF

pw.x < $INFILE > $OUTFILE 



bands.x < $INFILE > $OUTFILE

INFILE="$PREFIX.dos.in"
OUTFILE="$PREFIX.dos.out"

cat > $INFILE << EOF
&DOS
 prefix='$PREFIX',
 fildos='$PREFIX.dos'
 Emin=-8, Emax=18, DeltaE=0.1 
/
EOF

dos.x < $INFILE > $OUTFILE

INFILE="$PREFIX.pdos.in"
OUTFILE="$PREFIX.pdos.out"

cat > $INFILE << EOF
&PROJWFC
 prefix='$PREFIX',
 Emin=-8, Emax=18, DeltaE=0.01
 filpdos='$PREFIX.pdos',
 filproj='$PREFIX.proj'
/
EOF

projwfc.x < $INFILE > $OUTFILE


# rm *.igk *.wfc*
# rm -r *.save


