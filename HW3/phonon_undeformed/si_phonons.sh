#!/bin/bash
#SBATCH -J Si        # Job Name
#SBATCH -o Si.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 32            # Requests number of tasks, in multiples of 64
#SBATCH -p normal   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 10:00:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006
set -x   # Echo commands, use set echo with csh

x
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
 ecutwfc=50,
 ecutrho=500,
 occupations = 'fixed',
/
&ELECTRONS
 conv_thr = 1.0D-08,
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
  9 9 9 0 0 0

EOF

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

INFILE="$PREFIX.phon.in"
OUTFILE="$PREFIX.phon.out"

cat > $INFILE << EOF
Phonons of Si
&inputph
 tr2_ph=1.0d-16,
 amass(1)=28.0855d0,
 ldisp=.true.,
 nq1=4,nq2=4,nq3=4,
 prefix='$PREFIX',
 fildyn='silicon.dyn',
/

EOF

ph.x -ndiag 1 < $INFILE > $OUTFILE # Run the executable named ph.x
# -ndiag 1
# rm *.igk *.wfc*
# rm -r *.save


