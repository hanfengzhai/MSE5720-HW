#!/bin/bash
#SBATCH -J pto        # Job Name
#SBATCH -o pto.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -e pto.e%j
#SBATCH -N 1             # Requests nodes
#SBATCH -n 68            # Requests number of tasks, in multiples of 64
#SBATCH -p normal   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 10:00:00      # Run time (hh:mm:ss)
#SBATCH -A TG-BIO210063

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

PREFIX="PTO"
PSEUDO_DIR="./"
INFILE="$PREFIX.in"
OUTFILE="$PREFIX.out"

eta_list="4.0271 4.0352 4.0433 4.0514 4.0595 4.0676 4.0757"

for eta in $eta_list
do

cat > PTO.C33.$eta.in << EOF
&CONTROL
 calculation = 'relax',
 restart_mode = 'from_scratch',
 prefix='PTO2',
 pseudo_dir='./',
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
3.8558   0   0
0   3.8558   0
0   0   $eta

ATOMIC_POSITIONS crystal
Pb            0.0000000000        0.0000000000        1.0051904083
Ti            0.5000000000        0.5000000000        0.5395123895
O             0.5000000000        0.5000000000        0.0994787311
O             0.5000000000        0.0000000000        0.6115513795
O             0.0000000000        0.5000000000        0.6115513795

K_POINTS automatic
  7 7 5 0 0 0
EOF

pw.x < PTO.C33.$eta.in > PTO.C33.$eta.out # Run the executable named pw.x 

done
