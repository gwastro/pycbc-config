# Gating files for ER8A Chunk 2

Made using omicron and [https://github.com/samantha-usman/gating/blob/master/make_gating_from_omicron]

* H1-gating_SNR300-1125217722-574295.txt.gz
* L1-gating_SNR300-1125217722-574295.txt

## H1-gating_SNR300-1125217722-574295.txt.gz

```shell
ligolw_segment_query_dqsegdb --segment-url https://segments.ligo.org --query-segments --include-segments H1:DMT-ANALYSIS_READY:1 --exclude-segments H1:DCH-MISSING_H1_HOFT_C00:2 --gps-start-time 1123858817 --gps-end-time `lalapps_tconvert now` --output H1-SEGMENTS.xml
ligo_data_find --gps-start-time 1123858817 --gps-end-time `lalapps_tconvert now` --type H1_HOFT_C00 --lal-cache --observatory H --url-type file > cache.lcf
make_gating_from_omicron --start 1125217722 --end 1125792017 --ifo H1 --min-snr 300 --zeros 0.25 --pad 0.25 --cache-file omicron.lcf --verbose
```

```C++
// ------------------------------------------------------------------
// Omicron (v2r1) option file generated on Mon Sep 21 08:00:49 CDT 2015
// Configuration type = GW
// ------------------------------------------------------------------

DATA       FFL              /home/samantha.usman/aligo/er8/omicron/H1/frames.lcf
DATA       CHANNELS         H1:GDS-CALIB_STRAIN
DATA       SAMPLEFREQUENCY  8192

PARAMETER  CHUNKDURATION    544
PARAMETER  SEGMENTDURATION  64
PARAMETER  OVERLAPDURATION  4
PARAMETER  QRANGE           3.3166  100.0
PARAMETER  FREQUENCYRANGE   32  4096
PARAMETER  MISMATCHMAX      0.2
PARAMETER  SNRTHRESHOLD     5

OUTPUT     PRODUCTS         triggers
OUTPUT     VERBOSITY        0
OUTPUT     FORMAT           rootxml

// clustering is only applied to XML
PARAMETER  CLUSTERING       TIME


OUTPUT  DIRECTORY  /home/samantha.usman/aligo/er8/omicron/H1/triggers
```

Segment discrepancies are

```
[[1125234202 ... 1125234941)
 [1125250671 ... 1125255331)
 [1125258836 ... 1125260409)
 [1125272598 ... 1125276251)
 [1125291733 ... 1125295383)
 [1125315818 ... 1125331844)
 [1125331898 ... 1125331907)
 [1125331967 ... 1125342497)
 [1125381649 ... 1125392626)
 [1125392637 ... 1125418769)
 [1125419349 ... 1125432609)
 [1125436793 ... 1125436830)
 [1125439166 ... 1125444741)
 [1125444752 ... 1125446398)
 [1125463040 ... 1125472555)
 [1125485566 ... 1125495851)
 [1125499239 ... 1125525833)
 [1125550071 ... 1125646236)
 [1125684114 ... 1125685874)
 [1125685890 ... 1125696585)
 [1125702088 ... 1125703158)
 [1125713789 ... 1125714620)
 [1125714731 ... 1125733154)
 [1125747803 ... 1125759648)]
```

## L1-gating_SNR300-1125217722-574295.txt

```shell
ligolw_segment_query_dqsegdb --segment-url https://segments.ligo.org --query-segments --include-segments L1:DMT-ANALYSIS_READY:1 --exclude-segments L1:DCH-MISSING_L1_HOFT_C00:2 --gps-start-time 1123858817 --gps-end-time `lalapps_tconvert now` --output L1-SEGMENTS.xml
ligo_data_find --gps-start-time 1123858817 --gps-end-time `lalapps_tconvert now` --type L1_HOFT_C00 --lal-cache --observatory L --url-type file > frames.lcf
make_gating_from_omicron --start 1125217722 --end 1125792017 --ifo L1 --min-snr 300 --zeros 0.25 --pad 0.25 --cache-file omicron.lcf --verbose
```

```C++
// ------------------------------------------------------------------
// Omicron (v2r1) option file generated on Mon Sep 21 08:00:49 CDT 2015
// Configuration type = GW
// ------------------------------------------------------------------

DATA       FFL              /home/samantha.usman/aligo/er8/omicron/L1/frames.lcf
DATA       CHANNELS         L1:GDS-CALIB_STRAIN
DATA       SAMPLEFREQUENCY  8192

PARAMETER  CHUNKDURATION    544
PARAMETER  SEGMENTDURATION  64
PARAMETER  OVERLAPDURATION  4
PARAMETER  QRANGE           3.3166  100.0
PARAMETER  FREQUENCYRANGE   32  4096
PARAMETER  MISMATCHMAX      0.2
PARAMETER  SNRTHRESHOLD     5

OUTPUT     PRODUCTS         triggers
OUTPUT     VERBOSITY        0
OUTPUT     FORMAT           rootxml

// clustering is only applied to XML
PARAMETER  CLUSTERING       TIME

OUTPUT  DIRECTORY  /home/samantha.usman/aligo/er8/omicron/L1/triggers
```

Segment discrepancies are

```
[[1125217722 ... 1125234519)
 [1125278313 ... 1125278401)
 [1125278486 ... 1125278508)
 [1125279273 ... 1125295978)
 [1125297001 ... 1125309095)
 [1125319372 ... 1125320199)
 [1125320614 ... 1125323354)
 [1125323510 ... 1125330205)
 [1125334610 ... 1125335679)
 [1125335867 ... 1125338029)
 [1125340838 ... 1125341385)
 [1125355038 ... 1125356613)
 [1125365764 ... 1125370506)
 [1125372163 ... 1125423380)
 [1125465189 ... 1125472972)
 [1125511380 ... 1125514061)
 [1125516766 ... 1125530585)
 [1125530773 ... 1125538478)
 [1125582584 ... 1125583709)
 [1125584474 ... 1125589123)
 [1125591482 ... 1125593230)
 [1125593926 ... 1125594465)
 [1125594531 ... 1125597255)
 [1125599526 ... 1125601590)
 [1125601754 ... 1125606254)
 [1125606497 ... 1125610273)
 [1125610447 ... 1125611729)
 [1125612082 ... 1125612783)
 [1125612862 ... 1125615588)
 [1125624363 ... 1125640422)
 [1125641651 ... 1125645860)
 [1125647968 ... 1125653598)
 [1125710804 ... 1125719967)
 [1125721801 ... 1125723321)
 [1125723406 ... 1125732615)
 [1125745490 ... 1125747222)]
```

