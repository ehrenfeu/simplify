import xml.parsers.expat

# define the handler functions
def start_element(name, attrs):
    # print 'start element: "',name, '", "', attrs, '"'
    if name == 'ss:Worksheet':
        print "worksheet, attrs:", attrs

def char_data(data):
    print 'char data:', repr(data)

# set the file to read
infile = open('c:/Temp/green_single.xml')

p = xml.parsers.expat.ParserCreate('UTF-8')
p.StartElementHandler = start_element
# p.CharacterDataHandler = char_data

p.ParseFile(infile)
