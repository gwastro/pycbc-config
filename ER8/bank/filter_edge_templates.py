#! /usr/bin/env python

from glue.ligolw import utils
from glue.ligolw import table
from glue.ligolw import lsctables
from glue.ligolw import ligolw

from pycbc import pnutils

# for reading xmldocs
class LIGOLWContentHandler(ligolw.LIGOLWContentHandler):
    pass
lsctables.use_in(LIGOLWContentHandler)

# for writing xmldocs
def create_xmldoc(tables):
    """
    Creates an xmldoc from the list of given LIGOLW tables.
    """
    xmldoc = ligolw.Document()
    xmldoc.appendChild(ligolw.LIGO_LW())
    for table in tables:
        xmldoc.childNodes[0].appendChild(table)
    return xmldoc

input_bank = 'H1L1-UBERBANK_MAXM100_NS0p05_ER8HMPSD-1126033217-223200.xml.gz'
output_bank = 'H1L1-EDGEBIN_FROM_UBERBANK_ER8HMPSD-1126033217-223200.xml.gz'

xmldoc = utils.load_filename(input_bank, contenthandler=LIGOLWContentHandler,
    gz=True)
all_templates = table.get_table(xmldoc, 'sngl_inspiral')
# get the other tables that are in the document
other_table_names = [y.Name for y in xmldoc.childNodes[0].getElements(
    lambda x: x.tagName == ligolw.Table.tagName) if y.Name != u'sngl_inspiral']
other_tables = [table.get_table(xmldoc, x) for x in other_table_names]

keep_templates = lsctables.New(lsctables.SnglInspiralTable)

# only add templates that fall in the edge bin
for tmplt in all_templates:
    mchirp = pnutils.mass1_mass2_to_mchirp_eta(tmplt.mass1, tmplt.mass2)[0]
    peakfreq = pnutils.get_freq('fSEOBNRv2Peak', tmplt.mass1, tmplt.mass2,
        tmplt.spin1z, tmplt.spin2z)
    if mchirp >= 1.74 and peakfreq < 220.:
        keep_templates.append(tmplt)

outdoc = create_xmldoc(other_tables + [keep_templates])
utils.write_filename(outdoc, output_bank, gz=True)
