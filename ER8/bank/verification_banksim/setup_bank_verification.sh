#!/bin/bash

set -e

# set the following to the path to the PSD you want to use
PSD=/set/me
# set the following to the bank you want to test
BANK=/set/me

REPOURL=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/

BANKSIM_SCRIPT_PATH=`which pycbc_banksim`
ORIGDIR=${PWD}

for banksim in BNS_banksim NSBHbelow50_banksim NSBHabove50_banksim BBHbelow20_banksim BBHabove20_banksim
do
    mkdir ${banksim}
    curl ${REPOURL}/ER8/bank/verification_banksim/${banksim}.ini > ${banksim}/config.ini
    
    sed -i "s|BANKSIM_SCRIPT_PATH|${BANKSIM_SCRIPT_PATH}|" ${banksim}/config.ini
    sed -i "s|BANK_PATH|${BANK}|" ${banksim}/config.ini
    sed -i "s|PSD_PATH|${PSD}|" ${banksim}/config.ini
    sed -i "s|LOG_PATH|${TMP}|" ${banksim}/config.ini

    echo "SUBDAG EXTERNAL ${banksim} banksim.dag DIR ${banksim}" >> make_all_banksims.dag

    cd ${banksim}
    pycbc_make_banksim --config config.ini
    cd ${ORIGDIR}
done
