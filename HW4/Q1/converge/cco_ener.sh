#!/bin/bash	  
#SBATCH -J CCO-energy	 	# Job Name
#SBATCH -o CCO-energy.o%j	 # Name of the error and output files (%j appends the jobID)
#SBATCH -N 2             # Requests nodes
#SBATCH -n 120	         # Requests number of tasks, in multiples of 16 
#SBATCH -p normal	 # Queue name: development (max 1 hr walltime) or normal
#SBATCH -t 10:00:00	 # Run time (hh:mm:ss) 
#SBATCH -A TG-BIO210063
set -x	 # Echo commands, use set echo with csh

PREFIX="CCO_ener"
PSEUDO_DIR="./"
# INFILE="$PREFIX.in"
# OUTFILE="$PREFIX.out"

deform_list="30 40"
for ener in $deform_list
do
cat > cco.$ener.ener.new.in << EOF
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
 celldm(1)=12.1620d0,
 celldm(4)=0.6923d0,
 nat=10,
 ntyp=3,
 ecutwfc=$ener,
 occupations = 'fixed'
/
&ELECTRONS
 conv_thr = 1.0D-5,
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
Ca       0.000000000   0.000000000   0.000000000
C        0.250000000   0.250000000   0.250000000
C        0.750000000   0.750000000   0.750000000
O        0.506900245   0.993099755   0.250000000
O        0.993099755   0.250000000   0.506900245
O        0.250000000   0.506900245   0.993099755
O        0.006900245   0.750000000   0.493099755
O        0.750000000   0.493099755   0.006900245
O        0.493099755   0.006900245   0.750000000

K_POINTS automatic
  9 9 9 0 0 0
EOF

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < cco.$ener.ener.new.in > cco.$ener.ener.new.out # Run the executable named pw.x 

rm *.igk *.wfc*
rm -r *.save
rm -r _ph0
done
