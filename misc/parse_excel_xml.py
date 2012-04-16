import xml.parsers.expat

print_chardata = False

# define the handler functions
def start_element(name, attrs):
	global print_chardata
	# print 'start element: "',name, '", "', attrs, '"'
	if name == 'ss:Worksheet':
		print "worksheet, attrs:", attrs
		if 'ss:Name' in attrs:
			print attrs['ss:Name']
		print_chardata = True

def end_element(name):
	global print_chardata
	#print "end_element:", name
	if name == 'ss:Worksheet':
		print_chardata = False

def char_data(data):
	global print_chardata
	if print_chardata:
		data = data.strip()
		print 'char data:', repr(data)

# set the file to read
infile = open('c:/Temp/green_single.xml')

p = xml.parsers.expat.ParserCreate('UTF-8')
p.StartElementHandler = start_element
p.EndElementHandler = end_element
p.CharacterDataHandler = char_data

p.ParseFile(infile)
