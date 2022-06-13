#!/bin/bash	  
#SBATCH -J CCO-relax	 	# Job Name
#SBATCH -o CCO-relax.o%j	 # Name of the error and output files (%j appends the jobID)
#SBATCH -N 2             # Requests nodes
#SBATCH -n 120	         # Requests number of tasks, in multiples of 16 
#SBATCH -p normal	 # Queue name: development (max 1 hr walltime) or normal
#SBATCH -t 20:00:00	 # Run time (hh:mm:ss) 
#SBATCH -A TG-BIO210063
set -x	 # Echo commands, use set echo with csh

PREFIX="CCO"
PSEUDO_DIR="./"
INFILE="$PREFIX.in"
OUTFILE="$PREFIX.out"

cat > $INFILE << EOF
&CONTROL
 calculation = 'vc-relax',
 restart_mode = 'from_scratch',
 prefix='$PREFIX',
 pseudo_dir='$PSEUDO_DIR',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=5,
 celldm(1)=11.9984d0,
 celldm(4)=0.6933d0,
 nat=10,
 ntyp=3,
 ecutwfc=50,
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
/
ATOMIC_SPECIES
 Ca 40.078d0 Ca_PBE.UPF
 C 12.0107d0 C_PBE.UPF
 O 16.00d0 O_PBE.UPF

ATOMIC_POSITIONS (crystal)
Ca       0.500000000   0.500000000   0.500000000
Ca       0.000000000   0.000000000  -0.000000000
C        0.250000000   0.250000000   0.250000000
C        0.750000000   0.750000000   0.750000000
O        0.507001903   0.992998097   0.250000000
O        0.992998097   0.250000000   0.507001903
O        0.250000000   0.507001903   0.992998097
O        0.007001903   0.750000000   0.492998097
O        0.750000000   0.492998097   0.007001903
O        0.492998097   0.007001903   0.750000000

K_POINTS automatic
  9 9 9 0 0 0
EOF

module load intel/17.0.4
module load impi/17.0.3
module load qe/6.4.1

mpirun -np 120 pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

# rm *.igk *.wfc*
# rm -r *.save
# rm -r _ph0
