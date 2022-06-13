#!/bin/bash	  
#SBATCH -J CaTiO3	 # Job Name
#SBATCH -o CaTiO3.o%j	 # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 16	         # Requests number of tasks, in multiples of 16 
#SBATCH -p development	 # Queue name: development (max 1 hr walltime) or normal
#SBATCH -t 00:30:00	 # Run time (hh:mm:ss) 
#SBATCH -A TG-MPS150006
set -x	 # Echo commands, use set echo with csh

PREFIX="CTO"
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
 ibrav=1,
 celldm(1)=7.3573d0,
 nat=5,
 ntyp=3,
 ecutwfc=20,
 ecutrho=300,
 occupations = 'fixed'
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
 Ca 40.078d0 Ca_LDA.UPF
 Ti 47.88d0 Ti_LDA.UPF
 O  16.00d0 O_LDA.UPF

ATOMIC_POSITIONS
 Ca 0.d0 0.d0 0.d0
 Ti 0.5d0 0.5d0 0.505d0
 O 0.5d0 0.5d0 0.d0
 O 0.5d0 0.d0 0.5d0
 O 0.d0 0.5d0 0.5d0

K_POINTS automatic
  6 6 6 0 0 0

EOF

module load qe 

ibrun pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

rm *.igk *.wfc*
rm -r *.save

