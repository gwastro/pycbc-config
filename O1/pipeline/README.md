# O1 Pipeline Configuration files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_coinc_search_workflow`` generator on O1 data.

## Input Data ##

The files, see https://www.lsc-group.phys.uwm.edu/ligovirgo/cbcnote/PyCBC/O1SearchSchedule

 * gps_times_O1_analysis_0.ini
 * gps_times_O1_analysis_1.ini
 * gps_times_O1_analysis_2.ini


Contain the correct GPS time intervals and links to veto definer files for
ER8A and ER8B. Select the approriate file, depending on the analysis times. The file

 * data.ini

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
RUN_NAME=er8b
INI_PREFIX=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master

pycbc_make_coinc_search_workflow --workflow-name $RUN_NAME --output-dir output \
--config-files \
$INI_PREFIX/analysis.ini \
$INI_PREFIX/data.ini \
$INI_PREFIX/gps_times_O1_analysis_1.ini \
$INI_PREFIX/plotting.ini \
$INI_PREFIX/injections_minimal.ini \
$INI_PREFIX/excutables.ini \
--config-overrides \
"results_page:output-path:${HOME}/public_html/er8/er8b"
```

changing the output-path for the results page, the run name and the gps times as appropriate.

For production runs replace the executables.ini line with.

```
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-software/download/master/VERSION/x86_64/composer_xe_2015.0.090/executables.ini \
```

Where VERSION should be replaced with the desired code release. Also replace
'master' in the INI_PREFIX to the full hash of the desired configuration files.
