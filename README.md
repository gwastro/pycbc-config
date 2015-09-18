# PyCBC Configuration Files

This is the PyCBC configuration repository. This Git repo is for storing
configuration files for the search pipeline. This includes gating files,
template bank files, power spectra, and pipeline configuration (ini) files.

The repository is organized by run tag:

 * **S6** Configuration files for reproducing the S6 analysis.
 * **ER8** Configuration files for Engineering Run 8
 * **O1** Configuration files for Observing Run 1

with each run containing directories for the configuration files

 * **bank** for template banks used for the run
 * **pipeline** for files related to workflow generation and configuration

Data Quality and veto files can be found at

https://code.pycbc.phy.syr.edu/detchar/veto-definitions/tree/master/cbc
