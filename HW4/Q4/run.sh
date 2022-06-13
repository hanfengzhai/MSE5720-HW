#!/bin/bash
#SBATCH -J cco_phonon        # Job Name
#SBATCH -o cco_phonon.o%j    # Name of the error and output files (%j appends the jobID)
#SBATCH -N 2             # Requests nodes
#SBATCH -n 120            # Requests number of tasks, in multiples of 64
#SBATCH -p normal   # Queue name: development (max 2 hr walltime) or normal
#SBATCH -t 2:00:00      # Run time (hh:mm:ss)
#SBATCH -A TG-BIO210063

module load python2

mpirun -np 120 python2 IR_spectroscopy_script.py


