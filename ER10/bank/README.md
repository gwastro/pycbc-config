# ER10 template bank

Template bank for the PyCBC search on ER10 data and configuration file for its construction.

## Bank design

Investigations leading to the parameters of this bank are described in the
[PyCBC/O2TemplateBank wiki page](https://www.lsc-group.phys.uwm.edu/ligovirgo/cbcnote/PyCBC/O2TemplateBank).

Approximant: SEOBNRv4.2.

Masses: (1,1) to 500 total.

Minimum waveform duration: 0.15 s.

NS spins up to 0.05, BH spins up to 0.998 (Thorne limit).

Variable low-frequency cutoff, defined by a 0.5% range loss with respect to
starting at 15 Hz. Value stored in the `alpha6` column of the `sngl_inspiral`
table.

## Building the bank

First edit the paths to the PSD files in `config.ini` and point them the actual
location of the PSD files in your home directory. Then set up the bank
generation workflow:

```
pycbc_create_uberbank_workflow \
    --workflow-name bank_vlfc_thorne_hyperbank_er10psd \
    --output-dir output \
    --config-files config.ini
```

Move to the `output` directory and start the workflow with this command:

```
pycbc_submit_dax \
    --dax bank_vlfc_thorne_hyperbank_er10psd.dax \
    --accounting-group ligo.dev.o2.cbc.bbh.pycbcoffline
```
