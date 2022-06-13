#!/bin/bash	  
#SBATCH -J PbTiO3	 # Job Name
#SBATCH -o PbTiO3.o%j	 # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 30	         # Requests number of tasks, in multiples of 64 
#SBATCH -p development	 # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 01:00:00	 # Run time (hh:mm:ss) 
#SBATCH -A TG-BIO210063 
set -x	 # Echo commands, use set echo with csh

PREFIX="pto_ener"
PSEUDO_DIR="./"

# deform_list="150"
# for ener in $deform_list
# do
cat > pto.664.in << EOF
&CONTROL
 calculation = 'scf',
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
 ecutwfc=100,
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
   3.855813126   0.000000000   0.000000000
   0.000000000   3.855813126   0.000000000
   0.000000000   0.000000000   4.051423221

ATOMIC_POSITIONS crystal
Pb            0.0000000000        0.0000000000        1.0051904083
Ti            0.5000000000        0.5000000000        0.5395123895
O             0.5000000000        0.5000000000        0.0994787311
O             0.5000000000        0.0000000000        0.6115513795
O             0.0000000000        0.5000000000        0.6115513795

K_POINTS automatic
  6 6 4 0 0 0

EOF

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < pto.664.in > pto.664.out # Run the executable named pw.x 
done
# rm *.igk *.wfc* *.xml
# rm -r *.save

