# S6D Veto Definer File #

This directory contains the veto definer file used to obtain the S6 result with ihope and for reproducing the S6 result with PyCBC.

## H1L1V1-S6_CBC_LOWMASS_D_OFFLINE-961545543-0.xml ##

This file is the veto definer file used for the final S6D runs documented on the [S6 low-mass re-run page](https://www.lsc-group.phys.uwm.edu/ligovirgo/cbcnote/S6Plan/101104075619AnalysisS6ABC%20low%20mass%20re-runs). The specific file came from [sugar.phy.syr.edu](file://sugar.phy.syr.edu/home/spxiwh/S6/all_sky/S6_reruns/S6d_chunk3/968543943-971622087/segments/H1L1V1-S6_CBC_LOWMASS_D_OFFLINE-961545543-0.xml)

## H1L1V1-S6_CBC_LOWMASS_D_OFFLINE_WITH_BIGDOG-961545543-0.xml ##

This file is a copy of H1L1V1-S6_CBC_LOWMASS_D_OFFLINE-961545543-0.xml but with the following CAT3 flags removed so that the blind injection is not vetoed:

 * H1:DCH-INJECTION_INSPIRAL_BLIND:1
 * L1:DCH-INJECTION_INSPIRAL_BLIND:3
 * V1:INJECTION_INSPIRAL_BLIND:2
