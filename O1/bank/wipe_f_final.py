#!/usr/bin/env python

# This script reads a template bank, sets the f_final to zero for all
# templates and writes it to a new bank. This is needed when banks
# created by Sbank with ROMs are used with TaylorF2 terminating at ISCO.

import sys
from glue.ligolw import ligolw
from glue.ligolw import table
from glue.ligolw import lsctables
from glue.ligolw import utils as ligolw_utils
from glue import git_version


class ContentHandler(ligolw.LIGOLWContentHandler):
    pass
lsctables.use_in(ContentHandler)

indoc = ligolw_utils.load_filename(sys.argv[1], verbose=True,
                                   contenthandler=ContentHandler)

template_bank_table = table.get_table(indoc, lsctables.SnglInspiralTable.tableName)

for template in template_bank_table:
    template.f_final = 0

ligolw_utils.write_filename(indoc, sys.argv[2], gz=sys.argv[2].endswith('.gz'))
