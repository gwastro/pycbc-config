# O1 Pipeline Configuration files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_coinc_search_workflow`` generator on ER8A and ER8B data.

## Input Data ##

The files

 * N/A (no times yet) 

Contain the correct GPS time intervals and links to veto definer files for
O1. Select the approriate file, depending on the analysis times. The file

 * data_o1.ini

contains common data configuration parameters, including the channel names,
frame types, science segment names, and veto types to use.

## Analysis Configuration ##

The files

 * analysis.ini
 * plotting.ini
 * injections_minimal.ini

are the primary workflow configuration files. All three are required to run
the analysis.

## Workflow Generation ##

To generate a workflow to run the analysis from the latest version of the ini files:

 1. Make a new directory for running the analysis and cd into it
 2. Generate the workflow with the command
```
URL=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master
pycbc_make_coinc_search_workflow --workflow-name o1_chunk0 --output-dir output \
--config-files \
$URL/analysis.ini \
$URL/plotting.ini \
$URL/executables.ini \
$URL/injections_minimal.ini \
$URL/data_o1.ini \
$URL/o1_chunk0_times.ini \
--config-overrides \
"results_page:output-path:${HOME}/public_html/o1/chunk0"
```
changing the output-path for the results page as appropriate.

For production runs replace the executables.ini line with

 * N/A, o1 release not yet made
