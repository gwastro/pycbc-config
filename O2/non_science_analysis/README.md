This directory contains files for doing analysis on non-SCIENCE data.
These are generated in the following way.

 * Setup 3 runs
   * One using ANALYSIS READY as the science segment
   * One using ODC-READY as the science segment (`ODC-MASTER_OBS_READY:1`)
   * One using LOCKED as the science segment (`DMT-GRD_ISC_LOCK_NOMINAL:1`)
 * The runme.py script then uses the segment files that this produces as input to generate analysis segments. This basically works in the following way
   * Identify times in both H1 and L1 that are ODC-READY but not ANALYSIS READY
   * Take the union of those lists with times when both H1 and L1 are ODC-READY.
   * This is then times which become coincident after including ODC-READY
   * Segments are then protracted by 512s and we again take the union with ODC READY, now individually in each detector.
   * This allows short periods of ODC-READY within longer lock stretches to be analysed, but does mean we include some ANALYSIS READY + ANALYSIS READY times.
 * This process is then repeated with LOCKED and ODC-READY
 * The resulting segment files for H1 and L1 are then placed in the expected output location for a PyCBC coinc run.
 * A workflow is then generated with the "Rerun pre-existing segment files" option set to false (check the log to make sure segment files are being reused!!!)
 * Then it is submitted. Two runs.
