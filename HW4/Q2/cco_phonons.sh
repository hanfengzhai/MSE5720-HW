#!/bin/bash
#SBATCH -J cco_phonon        # Job Name
#SBATCH -o cco_phonon.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 2             # Requests nodes
#SBATCH -n 120            # Requests number of tasks, in multiples of 64
#SBATCH -p normal   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 48:00:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006
set -x   # Echo commands, use set echo with csh

# x
PREFIX="cco"
PSEUDO_DIR="./"
INFILE="$PREFIX.new_case120.in"
OUTFILE="$PREFIX.new_case120.out"

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
 ibrav=5,
 celldm(1)=12.16d0,
 celldm(4)=0.6932d0,
 nat=10,
 ntyp=3,
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

module load intel/19.1.1
module load impi/19.0.7
module load mvapich2/2.3.6
module load qe/7.0

pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

INFILE="$PREFIX.phon_newcase120.in"
OUTFILE="$PREFIX.phon_newcase120.out"

cat > $INFILE << EOF
Phonons of CaCO3
&inputph
 tr2_ph=1.0d-16,
 amass(1)=100.08d0,
 ldisp=.false.,
 nq1=4,nq2=4,nq3=4,
 prefix='$PREFIX',
 fildyn='cco.dyn',
/
0.d0 0.d0 0.d0
/

EOF

ph.x -ndiag 1 < $INFILE > $OUTFILE # Run the executable named ph.x
# -ndiag 1
# rm *.igk *.wfc*
# rm -r *.save


