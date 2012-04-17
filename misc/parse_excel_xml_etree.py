import xml.etree.ElementTree as etree
import sys

# for arg in sys.argv:
	# print arg

spots = []

# FIXME: we need a way to set infile if we're not called via execfile()
print "Processing file: " + infile
tree = etree.parse(infile)
print "Done parsing the XML."

expected_ns = 'urn:schemas-microsoft-com:office:spreadsheet'
myns = tree.getroot().tag[1:].split("}")[0]
if not myns == expected_ns:
	print "ERROR, this file doesn't have the expected XML namespace!"
	sys.exit(1)
print "Namespace parsed from XML document: '" + myns + "'"
print

# we're looking for stuff in the "Position" worksheet:
pattern = ".//{%s}Worksheet[@{%s}Name='Position']" % (myns, myns)
ws_position = tree.findall(pattern)

rows = ws_position[0].findall('.//{%s}Row' % myns)
for row in rows:
	for att in row.keys():
		print att + ' -> ' + row.get(att)
	etree.dump(row)
