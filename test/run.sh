export LIGO_DATAFIND_SERVER='128.230.190.43:80'

pycbc_make_coinc_search_workflow \
--workflow-name gw \
--output-dir output \
--config-files \
analysis.ini \
data_O1.ini \
plotting.ini \
injections_minimal.ini \
executables.ini \
gps_times_O1_analysis_1.ini \
--config-overrides \
"results_page:output-path:../../../html"
