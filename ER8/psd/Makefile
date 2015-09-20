# Use this Makefile to generate XML versions of PSD files

all: H1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz L1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz H1L1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz

H1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz: H1-ER8_HARM_MEAN_PSD-1126033217-223200.txt.gz
	gstlal_psd_xml_from_asd_txt --instrument H1 --type PSD $< --output $@

L1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz: L1-ER8_HARM_MEAN_PSD-1126033217-223200.txt.gz
	gstlal_psd_xml_from_asd_txt --instrument L1 --type PSD $< --output $@

H1L1-ER8_HARM_MEAN_PSD-1126033217-223200.xml.gz: H1L1-ER8_HARM_MEAN_PSD-1126033217-223200.txt.gz
	gstlal_psd_xml_from_asd_txt --instrument H1L1 --type PSD $< --output $@
