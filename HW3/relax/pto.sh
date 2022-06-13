#!/bin/bash	  
#SBATCH -J PbTiO3	 # Job Name
#SBATCH -o PbTiO3.o%j	 # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 30	         # Requests number of tasks, in multiples of 64 
#SBATCH -p development	 # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 01:00:00	 # Run time (hh:mm:ss) 
#SBATCH -A TG-MPS150006 
set -x	 # Echo commands, use set echo with csh

PREFIX="PTO_give"
PSEUDO_DIR="./"
INFILE="$PREFIX.in"
OUTFILE="$PREFIX.out"

cat > $INFILE << EOF
&CONTROL
 calculation = 'relax',
 restart_mode = 'from_scratch',
 prefix='$PREFIX',
 pseudo_dir='$PSEUDO_DIR',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=0,
 nat=5,
 ntyp=3,
 ecutwfc=50,
 ecutrho=500,
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
 Pb 207.2d0 Pb_LDA.UPF
 Ti 47.88d0 Ti_LDA.UPF
 O  16.00d0 O_LDA.UPF

CELL_PARAMETERS angstrom 
   3.9d0   0.000000000   0.000000000
   0.000000000   3.9d0   0.000000000
   0.000000000   0.000000000  4.1d0 

ATOMIC_POSITIONS crystal
Pb       0.000000000d0   0.000000000d0   1.006422508d0
Ti       0.500000000d0   0.500000000d0   0.540423697d0
O        0.500000000d0   0.500000000d0   0.098580301d0
O        0.500000000d0   0.000000000d0   0.610928891d0
O        0.000000000d0   0.500000000d0   0.610928891d0

K_POINTS automatic
  6 6 4 0 0 0

EOF

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

# rm *.igk *.wfc* *.xml
# rm -r *.save

