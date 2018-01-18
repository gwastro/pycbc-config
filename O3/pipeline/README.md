# O3 Pipeline Configuration Files #

This directory contains the necessary PyCBC workflow configuration files to
run the ``pycbc_make_coinc_search_workflow`` generator on ER10-O2 data.

## Analysis Configuration ##

The files

 * analysis.ini
 * plotting.ini
 * injections_minimal.ini

are the primary workflow configuration files. All three are required to run
the analysis.

To directly pull these files at runtime you can do something like:

```
GITHUB_TAG="SET_THIS_TO_SOMETHING_SANE"
GITHUB_URL="https://raw.githubusercontent.com/ligo-cbc/pycbc-config/${GITHUB_TAG}/O3/pipeline"

pycbc_make_coinc_search_workflow \
  --workflow-name ${WORKFLOW_NAME} --output-dir output \
  --config-files \
  ${GITHUB_URL}/analysis.ini \
  ${GITHUB_URL}/data.ini \
  ${GITHUB_URL}/executables.ini \
  ${GITHUB_URL}/injections.ini \
  ${GITHUB_URL}/plotting.ini \
  ```
