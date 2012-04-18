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
import numpy as np

def calc_dist_xyz(p1, p2):
	dx = abs(p2[0] - p1[0])
	dy = abs(p2[1] - p1[1])
	dz = abs(p2[2] - p1[2])
	dist = math.sqrt(dx**2 + dy**2 + dz**2)
	return(dist)

def dist(p1, p2):
	point1 = np.array(p1)
	point2 = np.array(p2)
	return(np.linalg.norm(point1 - point2))

def parse_xml(infile):
    print "Processing file: " + infile
    tree = etree.parse(infile)
    print "Done parsing the XML."
    print
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
    # extract positions and ID:
    for cell in table_cells:
        id = int(cell[7])
        x = float(cell[0])
        y = float(cell[1])
        z = float(cell[2])
        coords.insert(id, (x, y, z))
    print "Parsed coordinates:", str(len(coords))
    return(coords)

def main():
    if not len(sys.argv) == 3:
        print __doc__
        return(1)

    file1 = sys.argv[1]
    file2 = sys.argv[2]

    tree1 = parse_xml(file1)
    myns = check_namesp(tree1, 'urn:schemas-microsoft-com:office:spreadsheet')

    tree2 = parse_xml(file2)
    myns = check_namesp(tree2, 'urn:schemas-microsoft-com:office:spreadsheet')

    # we're looking for stuff in the "Position" worksheet:
    ws1_pos = get_worksheet(tree1, myns, 'Position')
    ws2_pos = get_worksheet(tree2, myns, 'Position')

    cells1 = parse_celldata(ws1_pos[0], myns)
    cells2 = parse_celldata(ws2_pos[0], myns)

    spots1 = IMS_extract_coords(cells1)
    spots2 = IMS_extract_coords(cells2)

    # test if calculation seems to be plausible:
    # spots1[len(spots1) - 1] = (59.84, 25.602, 1.161)

    for idx_orig, spot_orig in enumerate(spots2):
        # create a numpy array for the distances to all spots in file1
        distances = np.empty(len(spots1))
        print
        print 'Calculating closest neighbour.'
        # add an offset of 3 for the current dataset:
        print 'Original spot:  [' + str(idx_orig + 3) + ']', spot_orig
        for idx_rem, remote in enumerate(spots1):
            distances[idx_rem] = dist(spot_orig, remote)
        closest_id = distances.argmin()
        print "Neighbour spot: [" + str(closest_id) + ']', spots1[closest_id]
        print "Distance:", distances[closest_id]
    return(0)

# see http://www.artima.com/weblogs/viewpost.jsp?thread=4829
# for this nice way to handle the sys.exit()/return() calls
if __name__ == "__main__":
    sys.exit(main())
