# ER8 PyGRB Configuration files #

This directory contains the necessary configuration files to run the
``pycbc_make_offline_grb_workflow`` generator on ER8A and ER8B data.

## Main Analysis Configuration ##

The file

 * analysis_er8.ini

contains most of the primary analysis configuration parameters, including the
frame types, science segment names, and veto types to use. Also included are
the parameters for the inspiral matched filter jobs.

The file

 * injections_er8.ini

includes parameters for injection sets that are common to both online and
offline versions of the PyGRB search.

The post-processing parameters, used by plotting and results page generation,
are provided in

  * postprocessing_er8.ini

All three are required to run the analysis.

## ER8A / ER8B Options ##

The files

 * data_er8a.ini
 * data_er8b.ini

contain the correct veto definer files and template banks for the run
subdivisions ER8A and ER8B. Select the approriate file, depending on the
analysis times.

## Online/ Offline Options ##

The files

  * online_er8.ini
  * offline_er8.ini

contain, surprisingly, the parameters particular to the online and offline
versions of the PyGRB search respectively. These include frame types,
numbers of injections, and whether to run in single IFO mode.

## Workflow Generation ##

To generate a workflow to run the analysis from the latest version of the ini files:

 1. Make a new directory for running the analysis and cd into it
 2. Generate the workflow with the appropriate command, for example an offline ER8B GRB analysis:
```
pycbc_make_offline_grb_workflow \
--config-files \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pygrb/analysis_er8.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pygrb/injections_er8.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pygrb/postprocessing_er8.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pygrb/data_er8b.ini \
https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER8/pygrb/offline.ini \
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
