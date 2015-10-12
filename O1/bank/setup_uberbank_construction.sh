#!/bin/bash

# This script sets up a Condor DAG for constructing the combined template bank
# ("uberbank") for offline PyCBC searches in ER8/O1. See
# https://www.lsc-group.phys.uwm.edu/ligovirgo/cbcnote/ER8/pycbc_offline/combined_bank
#
# bash setup_uberbank_construction.sh
# condor_submit_dag make_uberbank.dag
#
# 2015 Tito Dal Canton

set -e

# base URLs to get required files from
REPOURL=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-config/download/master/
SWURL=https://code.pycbc.phy.syr.edu/ligo-cbc/pycbc-software/download/master/v1.2.0/x86_64/composer_xe_2015.0.090
# GPS times (mostly just for naming the final bank)
GPSSTART=1126051216
GPSEND=1127271616
# base PSD file name
PSD=H1L1-ER8B_HARM_MEAN_PSD-1126051216-1220400

FLOW=30
NSBHBOUNDARYMASS=2
BHSPIN=0.9895
NSSPIN=0.05

CONDORLOG=/local/user/${USER}/uberbank
rm -rf ${CONDORLOG}
mkdir -p ${CONDORLOG}
GPSDUR=`expr ${GPSEND} - ${GPSSTART}`
ORIGDIR=${PWD}

echo "---- Downloading required files ----"

PSDTXT=${ORIGDIR}/${PSD}.txt
PSDXML=${ORIGDIR}/${PSD}.xml
# we could keep them gzipped, but this ensures that the script fails
# should we hit a download issue and get an HTML page instead
curl ${REPOURL}/ER8/psd/${PSD}.txt.gz | gunzip > ${PSDTXT}
curl ${REPOURL}/ER8/psd/${PSD}.xml.gz | gunzip > ${PSDXML}

# get executables
curl ${REPOURL}/ER8/bank/wipe_f_final.py > wipe_f_final.py
chmod +x wipe_f_final.py
curl ${SWURL}/pycbc_geom_aligned_bank > pycbc_geom_aligned_bank
chmod +x pycbc_geom_aligned_bank
curl ${SWURL}/pycbc_geom_aligned_2dstack > pycbc_geom_aligned_2dstack
chmod +x pycbc_geom_aligned_2dstack
curl ${SWURL}/pycbc_aligned_bank_cat > pycbc_aligned_bank_cat
chmod +x pycbc_aligned_bank_cat
curl ${SWURL}/lalapps_cbc_sbank > lalapps_cbc_sbank
chmod +x lalapps_cbc_sbank
curl ${SWURL}/lalapps_cbc_sbank_pipe > lalapps_cbc_sbank_pipe
chmod +x lalapps_cbc_sbank_pipe
curl ${SWURL}/lalapps_cbc_sbank_choose_mchirp_boundaries > lalapps_cbc_sbank_choose_mchirp_boundaries
chmod +x lalapps_cbc_sbank_choose_mchirp_boundaries

#
# step 1: geometric
#

echo "---- Setting up geometric step ----"

BANK_STEP1=${ORIGDIR}/step1_geom/geom.xml.gz
# this is needed in order for pycbc_geom_aligned_bank
# to find the executables it needs for the DAG
OLDPATH=${PATH}
PATH=${ORIGDIR}:${PATH}

mkdir step1_geom
cd step1_geom

${ORIGDIR}/pycbc_geom_aligned_bank \
    --write-metric \
    --log-path ${CONDORLOG} \
    --psd-file ${PSDTXT} \
    --f-low ${FLOW} \
    --f-upper 1000 \
    --output-file ${BANK_STEP1} \
    --min-mass1 1 \
    --min-mass2 1 \
    --max-mass1 100 \
    --max-mass2 100 \
    --max-chirp-mass 1.5 \
    --ns-bh-boundary-mass ${NSBHBOUNDARYMASS} \
    --max-bh-spin-mag ${BHSPIN} \
    --max-ns-spin-mag ${NSSPIN} \
    --stack-distance 0.2 \
    --delta-f 0.01 \
    --split-bank-num 100 \
    --min-match 0.97 \
    --pn-order threePointFivePN \
    --verbose

PATH=${OLDPATH}

# set accounting group
sed -i 's/queue 1/accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline\n&/' *.sub

cd ${ORIGDIR}

#
# step 2: sbank with IMRPhenomD
#

echo "---- Setting up Sbank IMRPhenomD step ----"

BANK_STEP1_STEP2=${ORIGDIR}/step2_sbank_phenomd/geom_phenomd.xml.gz

mkdir step2_sbank_phenomd
cd step2_sbank_phenomd

cat <<EOT >> sbank.sub
universe = vanilla
executable = ${ORIGDIR}/lalapps_cbc_sbank
arguments = "--iterative-match-df-max 4 --gps-start-time ${GPSSTART} --gps-end-time ${GPSEND} --reference-psd ${PSDXML} --seed 101101 --user-tag PHENOMD --convergence-threshold 2500 --match-min 0.965 --instrument H1L1 --mass1-min 1 --mass1-max 99 --mass2-min 1 --mass2-max 99 --mchirp-min 1.4 --mchirp-max 1.9587387674162793 --ns-bh-boundary-mass ${NSBHBOUNDARYMASS} --bh-spin-min -${BHSPIN} --bh-spin-max ${BHSPIN} --ns-spin-min -${NSSPIN} --ns-spin-max ${NSSPIN} --aligned-spin --flow ${FLOW} --approximant IMRPhenomD --cache-waveforms --bank-seed ${BANK_STEP1} --fhigh-max 2048"
request_memory = 36000
copy_to_spool = False
getenv = True
notification = never
output = lalapps_cbc_sbank.stdout
error = lalapps_cbc_sbank.stderr
log = ${CONDORLOG}/uberbank
accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline
queue 1
EOT

cat <<EOT >> ligolwadd.sub
universe = vanilla
executable = `which ligolw_add`
arguments = "-o ${BANK_STEP1_STEP2} ${BANK_STEP1} H1L1-SBANK_PHENOMD-${GPSSTART}-${GPSDUR}.xml.gz"
request_memory = 1000
copy_to_spool = False
getenv = True
notification = never
output = ligolw_add.stdout
error = ligolw_add.stderr
log = ${CONDORLOG}/uberbank
accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline
queue 1
EOT

cd ${ORIGDIR}

#
# step 3: sbank with ROM (coarse pass)
#

echo "---- Setting up Sbank ROM coarse step ----"

BANK_STEP1_STEP2_STEP3=${ORIGDIR}/step3_sbank_rom1/geom_phenomd_rom1.xml.gz

mkdir step3_sbank_rom1
cd step3_sbank_rom1

cat <<EOT >> sbank.sub
universe = vanilla
executable = ${ORIGDIR}/lalapps_cbc_sbank
arguments = "--iterative-match-df-max 4 --gps-start-time ${GPSSTART} --gps-end-time ${GPSEND} --reference-psd ${PSDXML} --seed 101102 --user-tag ROM1 --convergence-threshold 250 --match-min 0.965 --instrument H1L1 --mass1-min 2 --mass1-max 99 --mass2-min 1 --mass2-max 99 --mtotal-min 4.5 --mtotal-max 100 --mratio-max 97 --ns-bh-boundary-mass ${NSBHBOUNDARYMASS} --bh-spin-min -${BHSPIN} --bh-spin-max ${BHSPIN} --ns-spin-min -${NSSPIN} --ns-spin-max ${NSSPIN} --aligned-spin --flow ${FLOW} --approximant SEOBNRv2_ROM_DoubleSpin --cache-waveforms --bank-seed ${BANK_STEP1_STEP2} --fhigh-max 2048"
request_memory = 36000
copy_to_spool = False
getenv = True
notification = never
output = lalapps_cbc_sbank.stdout
error = lalapps_cbc_sbank.stderr
log = ${CONDORLOG}/uberbank
accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline
queue 1
EOT

cat <<EOT >> ligolwadd.sub
universe = vanilla
executable = `which ligolw_add`
arguments = "-o ${BANK_STEP1_STEP2_STEP3} ${BANK_STEP1_STEP2} H1L1-SBANK_ROM1-${GPSSTART}-${GPSDUR}.xml.gz"
request_memory = 1000
copy_to_spool = False
getenv = True
notification = never
output = ligolw_add.stdout
error = ligolw_add.stderr
log = ${CONDORLOG}/uberbank
accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline
queue 1
EOT

cd ${ORIGDIR}

#
# step 4: sbank with ROM (fine pass)
#

echo "---- Setting up Sbank ROM fine step ----"

BANK_STEP1_STEP2_STEP3_STEP4=${ORIGDIR}/step4_sbank_rom2/H1-SBANK_COMBINED-SBANK.xml.gz

mkdir step4_sbank_rom2
cd step4_sbank_rom2

cat <<EOT >> config.ini
[condor]
; This section points to the executables, and provides condor options
universe = vanilla
lalapps_cbc_sbank = ${ORIGDIR}/lalapps_cbc_sbank
lalapps_cbc_sbank_splitter = /bin/true
lalapps_cbc_sbank_choose_mchirp_boundaries = ${ORIGDIR}/lalapps_cbc_sbank_choose_mchirp_boundaries
lalapps_cbc_sbank_sim = /bin/true
lalapps_cbc_sbank_plot_sim = /bin/true
lalapps_cbc_sbank_merge_sims = /bin/true
lalapps_inspinj = /bin/true

[sbank]
; This section contains the parameters of the entire bank parameter
; space you wish to cover. sbank_pipe will divide the space for you.
approximant = SEOBNRv2_ROM_DoubleSpin
match-min = 0.965
flow = ${FLOW}
reference-psd = ${PSDXML}
instrument = H1L1
mass1-min = 2
mass1-max = 99
mass2-min = 1
mass2-max = 99
mtotal-min = 4.5
mtotal-max = 100
mratio-max = 97
ns-bh-boundary-mass = ${NSBHBOUNDARYMASS}
bh-spin-max = ${BHSPIN}
bh-spin-min = -${BHSPIN}
ns-spin-max = ${NSSPIN}
ns-spin-min = -${NSSPIN}
aligned-spin =
gps-start-time = ${GPSSTART}
gps-end-time = ${GPSEND}
convergence-threshold = 2500
cache-waveforms =
iterative-match-df-max = 4
fhigh-max = 2048

[coarse-sbank]
; This section is for planning the splitting of the parameter
; space. To do so, we generate a "coarse" bank, i.e., a bank on the
; same parameter space but with much weaker convergence criteria. This
; process gives a very rough measure of the density of templates the
; final bank will require. I suggest to choose the right parameters by
; trial and error -- you don't want this step to take too long, but
; you want to have enough templates to accurate sample the space. My
; rule of thumb is that you want ~100 templates per split bank.
match-min = 0.9
convergence-threshold = 100

[split]
; This section configures the parallelization. nbanks are how many
; splits (in chirp mass) you want. You can crank it to infinity at the
; cost of overcoverage. template-weight is used internally to
; determine where to put the chirp mass boundaries. When you have a
; metric, set it to "equal", otherwise set to "duration". See the sbank_pipe
; help for more information.
nbanks = 100
template-weight = equal
; the minimum mchirp is an equal-mass M=4.5 binary
; (the lowest safe value I found for generating ROMs)
mchirp-min = 1.9587387674162793
; the maximum mchirp is a 50,50 binary
mchirp-max = 43.52752816480620600

[banksim]

[injections]
EOT

${ORIGDIR}/lalapps_cbc_sbank_pipe \
    --config-file config.ini \
    --bank-seed ${BANK_STEP1_STEP2_STEP3}

# set accounting group
sed -i 's/queue 1/accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline\n&/' *.sub
# correct memory requirements, default is not always enough
sed -i 's/request_memory =.*/request_memory = 10000/' lalapps_cbc_sbank.sub

cd ${ORIGDIR}

#
# zero out f_final
#

echo "---- Setting up wipe_f_final step ----"

BANK_FINAL=${ORIGDIR}/H1L1-UBERBANK-${GPSSTART}-${GPSDUR}.xml.gz

cat <<EOT >> wipeffinal.sub
universe = vanilla
executable = ${ORIGDIR}/wipe_f_final.py
arguments = "${BANK_STEP1_STEP2_STEP3_STEP4} ${BANK_FINAL}"
request_memory = 1000
copy_to_spool = False
getenv = True
notification = never
output = wipe_f_final.stdout
error = wipe_f_final.stderr
log = ${CONDORLOG}/uberbank
accounting_group = ligo.prod.o1.cbc.nsbh.pycbcoffline
queue 1
EOT

#
# write outer DAG
#

echo "---- Writing outer DAG ----"

cat <<EOT >> make_uberbank.dag
SUBDAG EXTERNAL geom bank_generation.dag DIR step1_geom
JOB sbank_phenomd_sbank sbank.sub DIR step2_sbank_phenomd
JOB sbank_phenomd_add ligolwadd.sub DIR step2_sbank_phenomd
JOB sbank_rom1_sbank sbank.sub DIR step3_sbank_rom1
JOB sbank_rom1_add ligolwadd.sub DIR step3_sbank_rom1
SUBDAG EXTERNAL sbank_rom2 SBANK.dag DIR step4_sbank_rom2
JOB wipeffinal wipeffinal.sub

PARENT geom CHILD sbank_phenomd_sbank
PARENT sbank_phenomd_sbank CHILD sbank_phenomd_add
PARENT sbank_phenomd_add CHILD sbank_rom1_sbank
PARENT sbank_rom1_sbank CHILD sbank_rom1_add
PARENT sbank_rom1_add CHILD sbank_rom2
PARENT sbank_rom2 CHILD wipeffinal
EOT
