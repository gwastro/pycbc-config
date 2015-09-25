# ER8 template banks

Here you can find scripts for building the uberbank for the combined offline PyCBC search over ER8
as well as actual bank files.

## Building the bank

[Uberbank wiki page](https://www.lsc-group.phys.uwm.edu/ligovirgo/cbcnote/ER8/pycbc_offline/combined_bank#Construction)

## Validating the template bank

Refer to the [PyCBC documentation on verifying banks](http://ligo-cbc.github.io/pycbc/latest/html/uberbank_verify.html?highlight=verify).
Configuration files are already provided in `verification_banksims`, as well as
a shell script to make the process easier. Download the script, edit the paths
to the PSD and bank to verify, and run it. The banksim config files will be
downloaded and the banksims will be prepared automatically. Then just submit
the DAG to run the full set of banksims.
