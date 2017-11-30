# O1 average noise PSD estimates

Average single-detector and multi-detector noise PSDs from the entire O1 data
using C02 calibration. The averaging uses the harmonic mean.

The workflow for generating this estimate can be set up as follows (remember
changing `WORKFLOW_NAME` and `OUTPUT_PATH` to something meaningful):

```
WORKFLOW_NAME=psd-estimation
OUTPUT_PATH=/path/to/html/summary/directory

pycbc_make_psd_estimation_workflow \
    --workflow-name ${WORKFLOW_NAME} \
    --output-dir output \
    --config-files \
        https://raw.githubusercontent.com/ligo-cbc/pycbc-config/master/O1/psd/C02_data/psd_estimation.ini \
        https://raw.githubusercontent.com/ligo-cbc/pycbc-config/master/O1/psd/C02_data/data.ini \
        https://raw.githubusercontent.com/ligo-cbc/pycbc-config/master/O1/psd/C02_data/gps_times.ini \
    --config-overrides \
        "results_page:output-path:${OUTPUT_PATH}"
```

When the above command completes successfully, submit the workflow:

```
cd output
pycbc_submit_dax --dax ${WORKFLOW_NAME}.dax --accounting-group ligo.prod.o1.cbc.nsbh.pycbcoffline
```

Wait until completion, then get the average PSDs and plots from the `output/psds`
and `output/plots` directories.

See the [general PyCBC documentation](http://ligo-cbc.github.io/pycbc/latest/html/workflow/pycbc_make_psd_estimation_workflow.html)
to understand the content of `psd_estimation.ini`.
