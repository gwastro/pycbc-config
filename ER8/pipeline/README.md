# ER8 Pipeline Configuration files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_coinc_search_workflow`` generator on ER8A and ER8B data.

## Input Data ##

The files

 * gps_times_er8a.ini
 * gps_times_er8b.ini

Contain the correct GPS time intervals and links to veto definer files for
ER8A and ER8B. Select the approriate file, depending on the analysis times. The file

 * data_er8.ini

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
pycbc_make_coinc_search_workflow --workflow-name er8b --output-dir output \
--config-files \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/c1ab4b89021e72dbc9dba2392ff1ab1a0ba60e3b/ER8/pipeline/analysis.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/c1ab4b89021e72dbc9dba2392ff1ab1a0ba60e3b/ER8/pipeline/data_er8.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/c1ab4b89021e72dbc9dba2392ff1ab1a0ba60e3b/ER8/pipeline/gps_times_er8b.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/c1ab4b89021e72dbc9dba2392ff1ab1a0ba60e3b/ER8/pipeline/plotting.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/c1ab4b89021e72dbc9dba2392ff1ab1a0ba60e3b/ER8/pipeline/injections_minimal.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pipeline/excutables.ini \
--config-overrides \
"results_page:output-path:${HOME}/public_html/er8/er8b"
```
changing the output-path for the results page as appropriate.

For production runs replace the executables.ini line with

```
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-software/download/master/v1.2.0/x86_64/composer_xe_2015.0.090/executables.ini \
```