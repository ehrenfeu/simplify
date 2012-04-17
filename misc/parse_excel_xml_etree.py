import xml.etree.ElementTree as etree
import sys

# for arg in sys.argv:
	# print arg
print infile

tree = etree.parse(infile)

expected_ns = 'urn:schemas-microsoft-com:office:spreadsheet'
myns = tree.getroot().tag[1:].split("}")[0]
if not myns == expected_ns:
	print "ERROR, this file doesn't have the expected XML namespace!"
print "namespace parsed from XML document:", myns

# etree.register_namespace('ss', 'urn:schemas-microsoft-com:office:spreadsheet')
# for uri, prefix in etree._namespace_map.items():
	# print "URI: ", uri, "  --  prefix:", prefix


# root = tree.getroot()
# print "tree.getroot():", root
# print "root.tag:", root.tag
# print

# etree.dump(tree)

#for child in root:
#	print "child:", child
#print

worksheets = tree.findall('{%s}Worksheet' % myns)
# print "worksheets:", worksheets
# for ws in worksheets:
	# print "---- worksheet attrib ----"
	# print ws.attrib
	# print "---- worksheet dump -----"
	# etree.dump(ws)
	# print


# t = tree.findall('{%s}Worksheet/{%s}Table' % myns)
# print t

pattern = ".//{%s}Worksheet[@{%s}Name='Position']" % (myns, myns)

ws_position = tree.findall(pattern)
etree.dump(ws_position[0])

#rows = t[0].findall('.//{%s}Row' % myns)
rows = tree.findall('.//{%s}Row' % myns)
for row in rows:
	etree.dump(row)
	# for child in row:
		# print "child:", child

