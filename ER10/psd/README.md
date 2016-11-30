# ER10 noise PSD estimates

Average single-detector and multi-detector noise PSDs from part of ER10
(2016-11-14 to 2016-11-21). The averaging uses the harmonic mean.

## Generating the PSDs

Set up the workflow with the following commands (editing `OUTPUT_PATH`
and `WORKFLOW_NAME` as needed):

```
WORKFLOW_NAME=psd-estim-er10-20161114-20161121
OUTPUT_PATH=${HOME}/public_html/o2/noise_psds/${WORKFLOW_NAME}

pycbc_make_psd_estimation_workflow \
    --workflow-name ${WORKFLOW_NAME} \
    --output-dir output \
    --config-files \
        psd_estimation.ini \
        data.ini \
        gps_times.ini \
    --config-overrides \
        "results_page:output-path:${OUTPUT_PATH}"
```

Then `cd output` and start the workflow with

```
pycbc_submit_dax \
    --dax psd-estim-er10-20161114-20161121.dax \
    --accounting-group ligo.dev.o2.cbc.nsbh.pycbcoffline
```
