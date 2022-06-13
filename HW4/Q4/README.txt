README
IR_spectroscopy_script.py
helpful_support.py

Scripts written by Jeff Kaarat

README written by Sabrina Li
You can either run IR_spectroscopy_script.py on Stampede, or run it on your personal computer if you have Python installed. This works with Python2 (haven't checked for Python3). Be sure to change the two file names to the appropriate path and name if the python script is not in the same directory as your ph.out file and your dynmat.out file.
The file you will use to plot is diel_output.txt. The phonon frequency is the first column. The next few columns are the Imaginary part of the index of refraction that corresponds to absorption: the height of peak is how strongly we except absorption.
You will be plotting specific ratios as specified in the homework assingment. 

The file is comma separated, so you can import them into Google Colab using:

import numpy as np
data = np.genfromtxt("filename", skip_header=1, delimiter=',')

Then you can do math on data, and then plot.