#!/bin/bash
#SBATCH -J diamond        # Job Name
#SBATCH -o diamond.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 15            # Requests number of tasks, in multiples of 64
#SBATCH -p development   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 00:30:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

kpoint_list="1 2 3 4 5 6 7 8 9 10 11"
for kpoint in $kpoint_list
do
cat > Diamond.k.$kpoint.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Diamond',
 pseudo_dir='../',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=6.74d0,
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
C 12.011d0 C_LDA.UPF

ATOMIC_POSITIONS
C 0.d0 0.d0 0.d0
C 0.25d0 0.25d0 0.25d0

K_POINTS automatic
  $kpoint $kpoint $kpoint 0 0 0

EOF

pw.x < Diamond.k.$kpoint.in > Diamond.k.$kpoint.out # Run the executable named pw.x 

done

# rm *.igk *.wfc*
# rm -r *.save


