# ER9/Towards-O2 Pipeline Configuration Files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_coinc_search_workflow`` generator on O1-ER9-O2 data.

## Input Data ##

The file

 * gps_times_ER9.ini

contains placeholders for the GPS time intervals and a link to veto definer file.
These will have to be added depending on what period is to be analyzed.

The file

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

To generate a production workflow to run the analysis, do the following:

 1. Make a new directory for running the analysis and cd into it. (Note: if you want to re-use data from a previous workflow, you should still create a new directory. Do not re-run the workflow generator in the same directory as your previous workflow or that will corrupt the old results). If you are generating a production workflow, you do not need to have any software installed. 
 1. Select a meaningful name for your workflow and set the shell variable ```WORKFLOW_NAME``` to this name. For example
```
WORKFLOW_NAME=er9test
```
 1. Determine where you want the results page written. This should be a
 LIGO.ORG protected web page appropriate for your cluster. On atlas, you
 should chose a directory under ```${HOME}/WWW/LSC``` and on other clusters
 you should chose a directory under ```${HOME}/public_html```. For example
```
OUTPUT_PATH=${HOME}/public_html/er9/testrun
```
 1. Determine the path to the pipeline configuration ini files that you want to use from the pipeline configuration repository and set the shell variable ```INI_PREFIX``` to the directory containing these files. To get the latest versions you can use
```
INI_PREFIX=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/ER9/pipeline
```
or to obtain a specific version for an analysis, you can change ```master``` to a git SHA hash, for example
```
INI_PREFIX=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/3d131118c27cf22d3b4c136d3f28c7e0fc6f9334/O1/pipeline
```
 1. Determine a location for the executables ini file. If you want to use locally installed executables, set this to 
```
EXEC_INI=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pipeline/executables.ini
```
or if you want to use a specific version of bundled executables for production analysis use e.g.
```
EXEC_INI=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-software/download/master/v1.3.x/x86_64/composer_xe_2015.0.090/executables.ini
```
NOTE that you will have to replace ```v1.3.x``` by the required release version. 
 1. Set a shell variable pointing to the URL of the GPS time configuration ini file, for example
```
GPS_INI=${INI_PREFIX}/gps_times_ER9.ini
```
 1. To avoid your proxy certificate being deleted when you log out of the cluster, create a new proxy with your uid in the filename by running
```
unset X509_USER_PROXY
ligo-proxy-init your.name
```
 1. Ask the cluster admins for the ROM data path in a specific cluster and set that path in your environment
```
export LAL_DATA_PATH=<full-ROM-data-path>:${LAL_DATA_PATH}
```
Note: if you decide to set the path in your .bash_profile, make sure to run "source .bash_profile" to make the change effective.
 1. Generate the workflow by running ```make_coinc_search_workflow``` e.g.
```
globus-url-copy -vb gsiftp://pycbc.phy.syr.edu/var/opt/gitlab/ligo-cbc/pycbc-software/v1.3.x/x86_64/composer_xe_2015.0.090/pycbc_make_coinc_search_workflow file://`pwd`/pycbc_make_coinc_search_workflow 
chmod +x pycbc_make_coinc_search_workflow
./pycbc_make_coinc_search_workflow --workflow-name ${WORKFLOW_NAME} --output-dir output \
--config-files \
${INI_PREFIX}/analysis.ini \
${INI_PREFIX}/data.ini \
${INI_PREFIX}/plotting.ini \
${INI_PREFIX}/injections_minimal.ini \
${GPS_INI} \
${EXEC_INI} \
--config-overrides \
"results_page:output-path:${OUTPUT_PATH}"
```

## Submitting the workflow ##

If you are not re-using data from a previous run, submit the workflow with the commands
```
cd output 
globus-url-copy -vb gsiftp://pycbc.phy.syr.edu/var/opt/gitlab/ligo-cbc/pycbc-software/v1.3.x/x86_64/composer_xe_2015.0.090/pycbc_submit_dax file://`pwd`/pycbc_submit_dax 
chmod +x pycbc_submit_dax
./pycbc_submit_dax --accounting-group ligo.prod.o1.cbc.bbh.pycbcoffline --dax ${WORKFLOW_NAME}.dax 
```

## Using pegasus-dashboard to check status of the workflow ##

You can use pegasus-dashboard to monitor the status of your workflow. You can find a summary of all of the workflows you have run at:

 * On atlas:
```
https://atlas${X}.atlas.aei.uni-hannover.de/pegasus/u/${USER_NAME}/
```
where ```${X}``` is the number of the machine from which you submited your dax (e.g., ```atlas8```) and ```${USER_NAME}``` is your user name on atlas.

 * On sugwg:
```
https://sugwg-${X}.phy.syr.edu/pegasus/u/${USER_NAME}/
```

where ```${X}``` is the name of the machine from which you submited your dax (e.g., ```condor``` or ```osg```) and ```${USER_NAME}``` is your username on sugwg.

 * On CIT (ldas-grid):
```
https://ldas-grid.ligo.caltech.edu/pegasus/u/${USER_NAME}/
```
where ```${USER_NAME}``` is your username on ldas-grid.

The workflow label in the table corresponds to the ```WORKFLOW_NAME``` you used when submitting the dax. Click on the one you used for this workflow;
that will take you to a summary of the jobs.

**Note:** If you have not used pegasus-dashboard before, those pages may not load for you. If so, log into the cluster and run the following:

```
chmod go+rx ~/.pegasus
chmod go+r ~/.pegasus/workflow.db
```

Then reload the page in your browser.

## Reusing data from a previous workflow ##

If you want to re-use data from a previous workflow, you need to make a cache file containing the files that you want to re-use. Locate the file ```main.map``` in the output directory of your previous workflow and copy it to the workflow directory for you new worflow **with a different name**, e.g. ```reuse_data.map```. Do not overwrite the ```main.map``` created by the new workflow.  Edit this file to contain only the data that you want to keep. Then pass it to the submission script with the ```--cache``` option, e.g.
```
./pycbc_submit_dax --accounting-group ligo.prod.o1.cbc.bbh.pycbcoffline --dax ${WORKFLOW_NAME}.dax --cache reuse_data.map
```
