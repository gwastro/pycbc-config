This directory contains a set of configuration files that can be used for
running small workflow tests to verify releases of the code. To use these
files to test a workflow, set the variable ```OUTPUT_PATH``` and run the
commands:
```shell
INI_PREFIX=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/pipeline
TEST_INI_PREFIX=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/workflow_test
pycbc_make_coinc_search_workflow --workflow-name test-workflow \
--output-dir output \
--config-files \
${INI_PREFIX}/executables.ini \
${INI_PREFIX}/analysis.ini \
${INI_PREFIX}/data.ini \
${INI_PREFIX}/plotting.ini \
${TEST_INI_PREFIX}/one_injection_run.ini \
${TEST_INI_PREFIX}/short_gps_interval.ini \
--config-overrides \
"results_page:output-path:${OUTPUT_PATH}" \
"workflow-coincidence:background-bins:bns:chirp:1.74 edge:SEOBNRv2Peak:220 bulk:total:150" \
"workflow-tmpltbank:tmpltbank-pregenerated-bank:https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/O1/workflow_test/H1L1-BIG_TEST_BANK-1129383017-1371600.xml.gz"

cd output/

pycbc_submit_dax --accounting-group ligo.dev.o1.cbc.bbh.pycbcoffline --dax test-workflow.dax
```
To test in non-shared filesystem mode, add the argument 
```shell
--append-pegasus-property 'pegasus.data.configuration=nonsharedfs'
```