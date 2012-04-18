#!/usr/bin/python

"""Parse Excel XML files into a python datastructure.
"""

# TODO:
#  - create a class for handling Excel XML, move to separate package
#  - do sanity checking
#  - evaluate datatypes from XML cells
#  - document functions

import xml.etree.ElementTree as etree
import sys
import math
import numpy

def calc_dist_xyz(p1, p2):
	dx = abs(p2[0] - p1[0])
	dy = abs(p2[1] - p1[1])
	dz = abs(p2[2] - p1[2])
	dist = math.sqrt(dx**2 + dy**2 + dz**2)
	return(dist)

def dist(p1, p2):
	point1 = numpy.array(p1)
	point2 = numpy.array(p2)
	return(numpy.linalg.norm(point1 - point2))

def parse_xml(infile):
    print "Processing file: " + infile
    tree = etree.parse(infile)
    print "Done parsing the XML."
    return(tree)

def check_namesp(xml_etree, expected_ns):
    real_ns = xml_etree.getroot().tag[1:].split("}")[0]
    if not real_ns == expected_ns:
        print "ERROR, this file doesn't have the expected XML namespace!"
        sys.exit(1)
    print "Namespace parsed from XML document: '" + real_ns + "'"
    print
    return(real_ns)

def get_worksheet(xml_etree, ns, pattern):
    pattern = ".//{%s}Worksheet[@{%s}Name='%s']" % (ns, ns, pattern)
    worksheet = xml_etree.findall(pattern)
    return(worksheet)

def parse_celldata(worksheet, ns):
    cells = []
    rows = worksheet.findall('.//{%s}Row' % ns)
    for row in rows:
        content = []
        # check if this is a header row:
        style_att = '{%s}StyleID' % ns
        if style_att in row.attrib:
            # currently we don't process the header rows, so skip to the next
            continue
        # print str(len(row))
        for cell in row:
            content.append(cell[0].text)
        # print content
        cells.append(content)
    # print cells
    # cells is now [ [r1c1, r1c2, r1c3, ...],
    #                [r2c1, r2c2, r2c3, ...],
    #                [r3c1, r3c2, r3c3, ...],
    #                ...                      ]
    print "Parsed rows: " + str(len(cells))
    return(cells)

def IMS_extract_coords(table_cells):
    coords = []
    for cell in table_cells:
        id = int(cell[7])
        x = float(cell[0])
        y = float(cell[1])
        z = float(cell[2])
        coords.insert(id, (x, y, z))
    print "Parsed coordinates:", str(len(coords))
    return(coords)

if len(sys.argv) > 1:
	infile = sys.argv[1]

tree = parse_xml(infile)

myns = check_namesp(tree, 'urn:schemas-microsoft-com:office:spreadsheet')

# we're looking for stuff in the "Position" worksheet:
ws_pos = get_worksheet(tree, myns, 'Position')

cells = parse_celldata(ws_pos[0], myns)

spots = []

# extract positions and ID:
cellno = 0
id = int(cells[cellno][7])
pos_x = float(cells[cellno][0])
pos_y = float(cells[cellno][1])
pos_z = float(cells[cellno][2])

coordinates = (pos_x, pos_y, pos_z)
spots.insert(id, coordinates)

# print spots[cellno]
# # print calc_dist_xyz((0,0,0), spots[0])
# print dist((0,0,0), spots[cellno])
# # print calc_dist_xyz((0,0,0), (3,4,0))
# print dist((0,0,0), (3,4,0))
# # print spots[444]

for spot in spots:
	dist((0,0,0), spot)
print "Calculated all distances to (0,0,0)"
