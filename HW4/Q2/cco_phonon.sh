#!/bin/bash
#SBATCH -J cco_band        # Job Name
#SBATCH -o cco_band.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 1             # Requests nodes
#SBATCH -n 68            # Requests number of tasks, in multiples of 64
#SBATCH -p development   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 02:00:00      # Run time (hh:mm:ss)
#SBATCH -A TG-MPS150006
set -x   # Echo commands, use set echo with csh


module load intel/17.0.4
module load impi/17.0.3
module load qe/6.4.1

PREFIX="CCO"
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
 ibrav=5,
 celldm(1)=12,
 celldm(4)=0.5,
 nat=10,
 ntyp=3,
 nbnd=8,
 ecutwfc=50,
 ecutrho=500,
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
 Ca 40.078d0 Ca_PBE.UPF
 C 12.0107d0 C_PBE.UPF
 O 16.00d0 O_PBE.UPF

ATOMIC_POSITIONS (crystal)
Ca       0.500000000   0.500000000   0.500000000
Ca       0.000000000   0.000000000   0.000000000
C        0.250000000   0.250000000   0.250000000
C        0.750000000   0.750000000   0.750000000
O        0.508611069   0.991388931   0.250000000
O        0.991388931   0.250000000   0.508611069
O        0.250000000   0.508611069   0.991388931
O        0.008611069   0.750000000   0.491388931
O        0.750000000   0.491388931   0.008611069
O        0.491388931   0.008611069   0.750000000

K_POINTS automatic
  12 12 12 0 0 0

EOF


mpirun -np 68 pw.x < $INFILE > $OUTFILE # Run the executable named pw.x 

INFILE="$PREFIX.bands.in"
OUTFILE="$PREFIX.bands.out"

cat > $INFILE << EOF
&CONTROL
 calculation = 'bands',
 prefix='$PREFIX',
 pseudo_dir='$PSEUDO_DIR',
/
&SYSTEM
 ibrav=5,
 celldm(1)=12,
 celldm(4)=0.5,
 nat=2,
 ntyp=1,
 nbnd=8,
 ecutwfc=50,
 ecutrho=500,
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
 Ca 40.078d0 Ca_PBE.UPF
 C 12.0107d0 C_PBE.UPF
 O 16.00d0 O_PBE.UPF

ATOMIC_POSITIONS (crystal)
Ca       0.500000000   0.500000000   0.500000000
Ca       0.000000000   0.000000000   0.000000000
C        0.250000000   0.250000000   0.250000000
C        0.750000000   0.750000000   0.750000000
O        0.508611069   0.991388931   0.250000000
O        0.991388931   0.250000000   0.508611069
O        0.250000000   0.508611069   0.991388931
O        0.008611069   0.750000000   0.491388931
O        0.750000000   0.491388931   0.008611069
O        0.491388931   0.008611069   0.750000000

K_POINTS tpiba_b 
3
0.5d0 0.5d0 0.5d0 20
0.d0 0.d0 0.d0 20
1.d0 0.d0 0.d0 20

EOF

mpirun -np 68 pw.x < $INFILE > $OUTFILE # Run the executable named pw.x

INFILE="$PREFIX.plot.in"
OUTFILE="$PREFIX.plot.out"

cat > $INFILE << EOF
&BANDS
 prefix='$PREFIX',
 filband="CCO.bandsplot"
/

EOF

mpirun -np 68 bands.x < $INFILE > $OUTFILE

INFILE="$PREFIX.dos.in"
OUTFILE="$PREFIX.dos.out"

cat > $INFILE << EOF
&DOS
 prefix='$PREFIX',
 fildos='$PREFIX.dos'
 Emin=-8, Emax=18, DeltaE=0.1 
/
EOF

mpirun -np 68 dos.x < $INFILE > $OUTFILE

INFILE="$PREFIX.pdos.in"
OUTFILE="$PREFIX.pdos.out"

cat > $INFILE << EOF
&PROJWFC
 prefix='$PREFIX',
 Emin=-8, Emax=18, DeltaE=0.1
 filpdos='$PREFIX.pdos',
 filproj='$PREFIX.proj'
/
EOF

mpirun -np 68 projwfc.x < $INFILE > $OUTFILE


# rm *.igk *.wfc*
# rm -r *.save


