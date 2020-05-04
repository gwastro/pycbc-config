# O2 C02 data 3-ifo Configuration Files #

To generate the workflow, download the ini files form this directory and then run the following.

You can change the settings on the first few lines to use a different chunk of data.
```
GPSSTART=1185937218
GPSEND=1186624818
CHUNKNUMBER='20'
WORKFLOW_NAME=o2_HLV

pycbc_create_offline_search_workflow \
  --workflow-name ${WORKFLOW_NAME} --output-dir output \
  --config-files \
    analysis.ini \
    gating.ini \
    data_O2_C02.ini \
    minimal_injections.ini \
    executables.ini \
    plotting.ini \
  --config-overrides workflow:start-time:${GPSSTART} workflow:end-time:${GPSEND} \
    'results_page:analysis-title:"PyCBC hyperbank search"' \
    'results_page:analysis-subtitle:"O2 analysis, chunk '${CHUNKNUMBER}'."' \
    results_page:output-path:"/home/${USER}/public_html/analyses/o2_${CHUNKNUMBER}"

```

To submit the workflow, `cd` into the newly created `output` directory, and run:
```
pycbc_submit_dax --dax o2_HLV.dax --no-grid
```
