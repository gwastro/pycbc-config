# O2 PyGRB Configuration Files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_offline_grb_workflow`` generator on ER10-O2 data.
This is currently used to generate all production PyGRB workflows.

## Analysis Configuration ##

The files

 * analysis_o2.ini
 * injections_o2.ini
 * postprocessing_o2.ini

are the primary workflow configuration files. All three are required to run
the analysis. In addition, specific options for running on offline data are
included. Trigger-specific options will also be required.

An template workflow generation command is given below:

```
GITHUB_TAG="SET_THIS_TO_SOMETHING_SANE"
GITHUB_URL="https://raw.githubusercontent.com/ligo-cbc/pycbc-config/${GITHUB_TAG}/O2/pygrb"
TRIGGER_NAME="GRBYYMMDDxxx"
export LAL_SRC=$VIRTUAL_ENV/src/lalsuite
pycbc_make_offline_grb_workflow \
    --config-files \
    ${GITHUB_URL}/executables.ini \
    ${GITHUB_URL}/analysis_o2.ini \
    ${GITHUB_URL}/injections_o2.ini \
    ${GITHUB_URL}/postprocessing_o2.ini \
    ${GITHUB_URL}/offline_o2.ini \
    ${GITHUB_URL}/grbs/${TRIGGER_NAME}.ini
```
