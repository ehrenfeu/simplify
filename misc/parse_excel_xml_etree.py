#!/usr/bin/python

import xml.etree.ElementTree as etree
import sys
import math
# import numpy

# for arg in sys.argv:
	# print arg

def calc_dist_xyz(p1, p2):
	dx = abs(p2[0] - p1[0])
	dy = abs(p2[1] - p1[1])
	dz = abs(p2[2] - p1[2])
	dist = math.sqrt(dx**2 + dy**2 + dz**2)
	return(dist)
	# a = numpy.array(p1)
	# b = numpy.array(p2)

spots = []

if len(sys.argv) > 1:
	infile = sys.argv[1]
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
print spots[0]
print calc_dist_xyz((0,0,0), spots[0])
print calc_dist_xyz((0,0,0), (3,4,0))
# print spots[444]
