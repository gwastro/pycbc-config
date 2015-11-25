# O1 PyGRB Configuration files #

This directory contains the necessary configuration files to run the
``pycbc_make_offline_grb_workflow`` generator on O1 data.

## Main Analysis Configuration ##

The file

 * analysis_o1.ini

contains most of the primary analysis configuration parameters, including the
frame types, science segment names, and veto types to use. Also included are
the parameters for the inspiral matched filter jobs.

The file

 * injections_o1.ini

includes parameters for injection sets that are common to both online and
offline versions of the PyGRB search.

The post-processing parameters, used by plotting and results page generation,
are provided in

  * postprocessing_o1.ini

The veto definer files and template banks for the run are found in

 * data_o1.ini

All four are required to run the analysis.

## Online/ Offline Options ##

The files

  * online_o1.ini
  * offline_o1.ini

contain, surprisingly, the parameters particular to the online and offline
versions of the PyGRB search respectively. These include frame types,
numbers of injections, and whether to run in single IFO mode.

## Workflow Generation ##

To generate a workflow to run the analysis from the latest version of the ini files:

 1. Make a new directory for running the analysis and cd into it
 2. Generate the workflow with the appropriate command, for example an offline O1 GRB analysis:
```
pycbc_make_offline_grb_workflow \
--config-files \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pygrb/analysis_o1.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pygrb/injections_o1.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pygrb/postprocessing_o1.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pygrb/data_o1.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pygrb/offline.ini \
--config-overrides \
workflow:output-directory:${OUT_DIR} \
workflow:ra:${RA} \
workflow:dec:${DEC} \
workflow:sky-error:${SKY_ERROR} \
workflow:trigger-name:${GRB_NAME} \
workflow:trigger-time:${GRB_TIME} \
workflow:start-time:$(( GRB_TIME - 5096 )) \
workflow:end-time:$(( GRB_TIME + 5096 )) \
workflow:html-dir:${HTML_DIR}
```
  setting/changing/populating the config-overrides as appropriate.
