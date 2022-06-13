#!/bin/bash
#SBATCH -J Si        # Job Name
#SBATCH -o Si.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -e ecut%j.err                        # error log file (%j expands to jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 30            # Requests number of tasks, in multiples of 64
#SBATCH -p development   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 00:30:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

ecut_list="20 30 40 50 60 70 80 90 100 110"
for ecut in $ecut_list
do
cat > Si.$ecut.in << EOF
&CONTROL
 calculation = 'scf',
 restart_mode = 'from_scratch',
 prefix='Si',
 pseudo_dir='./',
 tstress=.true.,
 tprnfor=.true.,
/
&SYSTEM
 ibrav=2,
 celldm(1)=10.2d0,
 nat=2,
 ntyp=1,
 ecutwfc=$ecut,
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
3 3 3 0 0 0
EOF


pw.x < Si.$ecut.in > Si.$ecut.out # Run the executable named pw.x 

# rm *.igk *.wfc*
# rm -r *.save

done