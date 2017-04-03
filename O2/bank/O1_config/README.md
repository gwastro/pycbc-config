# O1 template bank with O2 PSD

Template bank for the PyCBC search using the O1 Configuration from the uberbank but with O2 PSDs.

## Bank design

Investigations leading to the parameters of this bank are described in the
[PyCBC/Template Bank Documentation](https://ligo-cbc.github.io/pycbc/latest/html/tmpltbank.html#hybrid-approaches-the-best-of-both-worlds).

Approximant: SEOBNRv2_ROM_DoubleSpin_HI

Masses: (1,1) to 100 total.

NS spins up to 0.05, BH spins up to 0.9899.

30 Hz low-frequency cutoff.

See attached bank plot with O1 background bins placed in.

See Documentation for full details.

## Building the bank

First edit the paths to the PSD files in `config.ini` and point them the actual
location of the PSD files in your home directory. Then set up the bank
generation workflow:

```
pycbc_create_uberbank_workflow \
    --workflow-name O1_config_with_O2_PSD \
    --output-dir output \
    --config-files O1_uberbank.ini
```

Move to the `output` directory and start the workflow with this command:

```
pycbc_submit_dax \
    --dax O1_config_with_O2_PSD.dax \
    --accounting-group ligo.dev.o2.cbc.bbh.pycbcoffline
```

