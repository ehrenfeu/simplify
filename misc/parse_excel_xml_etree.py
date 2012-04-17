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
	# check if this is a header row:
	style_att = '{%s}StyleID' % myns
	if style_att in row.attrib:
		# currently we don't process the header rows, so skip to the next
		continue
	# extract positions and ID:
	id = int(row[7][0].text)
	pos_x = float(row[0][0].text)
	pos_y = float(row[1][0].text)
	pos_z = float(row[2][0].text)
	
	coordinates = (pos_x, pos_y, pos_z)
	spots.insert(id, coordinates)
	
print "Parsed spots: " + str(len(spots))
print spots[444]
