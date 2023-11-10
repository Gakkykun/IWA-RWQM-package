# IWA River Water Quality Model No.1 simulation and sensitivity and identifiability analyses

This repository contains Fortran and Python programs to replicate the work presented in [Inagaki et al, (2023)](https://doi.org/10.2166/wpt.2023.166). They were tested in Ubuntu 20.04 (They would be run without issues on a Windows machine as well). If you face issues to run the code, please email me. 

## Usage of Python

1. Clone this repository
2. Run `conda conda env create -f environmnet.yml` 
3. Run `conda activate iwa-simulation`
4. Install an additional library called "SciencePlots" developed by John D. Garrett (see more details at https://github.com/garrettj403/SciencePlots), running `pip install git+https://github.com/garrettj403/SciencePlots` Please make sure that you installed Latex in advance, otherwise you will get an error. Alternatively, you can comment out code related to this library.

## Building a Fortran program and display results
### Compare observed and modeled flow velocties
 - Move to the "output-flow" floder with `cd output-flow` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`
 - Run `python linearRegression.py`

### Calibrate flow-related parameters
 - Move to the "calibration-flow" floder with `cd calibration-flow` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`

### Run water quality simulation and display results
 - Move to the "output" floder with `cd output` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`
 - Give either 1, 2, or 3 as an comand line argument such as `python plot-compiled.py 1`, which means a data set number was set to 1. Created png files will be stored in the `png-compiled` folder.
 - Give either 1, 2, or 3 as an comand line argument such as `python plot.py 1`, which means a data set number was set to 1. Created png files will be stored in the `png` folder.

### Calibrate kinetic parameters
 - Move to the "calibration-kinetic" floder with `cd calibration-kinetic` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`

### Analyze sensitivities of kinetic parameters 
 - Move to the "sensitivity-kinetic" floder with `cd sensitivity-kinetic` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`
 - Give either 1, 2, or 3 as an comand line argument such as `python sensitivity-test-kinetic.py 1`, which means a data set number was set to 1.

### Analyze sensitivities of water quality of Jyokaso
 - Move to the "sensitivity-WQ" floder with `cd sensitivity-WQ` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`
 - Give either 1, 2, or 3 as an comand line argument such as `python sensitivity-test-WQ.py 1`, which means a data set number was set to 1.

### Scenario analysis
 - Move to the "scenario" floder with `cd scenario` if you are in `IWA-RWQM-package`
 - Run `make cleanall`
 - Run `make all`
 - Run `./main`
 - Run `jupyter lab`
 - Select `plot-compare.ipynb` in a launched web browser, and run all of cells.


### Statistical analysis
 - Move to the "python-data-processing" floder with `cd python-data-processing` if you are in `IWA-RWQM-package`
 - Run `python stats-analysis.py`

### Parallel coordinate
 - Move to the "python-data-processing" floder with `cd python-data-processing` if you are in `IWA-RWQM-package`
 - Run `python parallel-coordinates.py` and then two png files will be created
