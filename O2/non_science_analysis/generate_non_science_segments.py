import copy
from pycbc.workflow import SegFile

ldas_segs = {}
locked_segs = {}
odc_segs = {}

for ifo in ['H1','L1']:
    ldas = '{}-LDAS_SEGMENTS.xml'.format(ifo)
    locked = '{}-LOCKED_SEGMENTS.xml'.format(ifo)
    odc = '{}-ODCREADY_SEGMENTS.xml'.format(ifo)
    ldas_file = SegFile.from_segment_xml(ldas)
    locked_file = SegFile.from_segment_xml(locked)
    odc_file = SegFile.from_segment_xml(odc)
    ldas_segs[ifo] = ldas_file.return_union_seglist()
    locked_segs[ifo] = locked_file.return_union_seglist()
    odc_segs[ifo] = odc_file.return_union_seglist()

print abs(ldas_segs['H1']), abs(ldas_segs['L1'])
# Case 1: Nominal, but not READY
nominal_h = odc_segs['H1'] - ldas_segs['H1']
print abs(odc_segs['H1'])
print abs(nominal_h)
subnominal_h = locked_segs['H1'] - odc_segs['H1']
print abs(subnominal_h)

nominal_l = odc_segs['L1'] - ldas_segs['L1']
print abs(nominal_l)
subnominal_l = locked_segs['L1'] - odc_segs['L1']
print abs(subnominal_l)

nominal_both = nominal_h | nominal_l
nominal_both.coalesce()
print abs(nominal_both)
# Remove short segments
#nominal_both.protract(512)
nominal_both.coalesce()
print abs(nominal_both)
nominal_both = nominal_both & odc_segs['H1']
nominal_both = nominal_both & odc_segs['L1']
print abs(nominal_both)
nominal_h1 = copy.deepcopy(nominal_both)
nominal_h1.protract(512)
nominal_h1 = nominal_h1 & odc_segs['H1']

print "H1 NOMINAL:", abs(nominal_h1), len(nominal_h1)
nom_h1_file = SegFile.from_segment_list('NOMINAL_SCIENCE', nominal_h1, 'NOMINAL_SCIENCE', 'H1', extension='.xml', directory='.')
#nom_h1_file.to_segment_xml()

nominal_l1 = copy.deepcopy(nominal_both)
nominal_l1.protract(512)
nominal_l1 = nominal_l1 & odc_segs['L1']

print "L1 NOMINAL:", abs(nominal_l1)
nom_l1_file = SegFile.from_segment_list('NOMINAL_SCIENCE', nominal_l1, 'NOMINAL_SCIENCE', 'L1', extension='.xml', directory='.')
#nom_l1_file.to_segment_xml()

print

subnominal_both = subnominal_h | subnominal_l
subnominal_both.coalesce()
print abs(subnominal_both)
subnominal_both = subnominal_both & locked_segs['H1']
subnominal_both = subnominal_both & locked_segs['L1']
print abs(subnominal_both)
subnominal_h1 = copy.deepcopy(subnominal_both)
subnominal_h1.protract(512)
subnominal_h1 = subnominal_h1 & locked_segs['H1']

print "H1 SUBNOMINAL", abs(subnominal_h1)
subnom_h1_file = SegFile.from_segment_list('SUBNOMINAL_SCIENCE', subnominal_h1, 'SUBNOMINAL_SCIENCE', 'H1', extension='.xml', directory='.')
#nom_h1_file.to_segment_xml()

subnominal_l1 = copy.deepcopy(subnominal_both)
subnominal_l1.protract(512)
subnominal_l1 = subnominal_l1 & locked_segs['L1']

print "L1 SUBNOMINAL", abs(subnominal_l1)
subnom_l1_file = SegFile.from_segment_list('SUBNOMINAL_SCIENCE', subnominal_l1, 'SUBNOMINAL_SCIENCE', 'L1', extension='.xml', directory='.')
#nom_l1_file.to_segment_xml()
