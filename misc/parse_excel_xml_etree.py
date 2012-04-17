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

pattern = ".//{%s}Worksheet[@{%s}Name='Position']" % (myns, myns)

ws_position = tree.findall(pattern)
# etree.dump(ws_position[0])

print

#rows = t[0].findall('.//{%s}Row' % myns)
# rows = tree.findall('.//{%s}Row' % myns)
rows = ws_position[0].findall('.//{%s}Row' % myns)
for row in rows:
	for att in row.keys():
		print att + ' -> ' + row.get(att)
	etree.dump(row)
