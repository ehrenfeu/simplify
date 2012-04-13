#!/usr/bin/python
# -*- coding: utf-8 -*-

import sys
import pyexiv2

try:
    from pyexiv2 import ImageMetadata
except ImportError:
    print 'Error loading required module "ImageMetadata" from pyexiv2.'
    sys.exit(1)

copy_tags = {
    'GPSInfo': (
        'GPSVersionID', 
        'GPSLatitudeRef',
        'GPSLatitude',
        'GPSLongitudeRef',
        'GPSLongitude',
        'GPSTimeStamp',
        'GPSSatellites',
        'GPSStatus',
        'GPSMeasureMode',
        'GPSDOP',
        'GPSMapDatum',
        'GPSProcessingMethod',
        'GPSDateStamp',
    ),
}

# print copy_tags

if __name__ == '__main__':
    """
    FIXME
    """

    ver_libexiv2_min = (0, 21, 1)
    ver_pyexiv2_min = (0, 3, 0)
    try: 
        ver_pyexiv2 = pyexiv2.version_info
        ver_libexiv2 = pyexiv2.exiv2_version_info
    except AttributeError:
        print 'Error determining version numbers.'
        sys.exit(0)

    if (ver_libexiv2 < ver_libexiv2_min):
        print 'Newer version of libexiv2 required.'
        sys.exit(1)
    if (ver_pyexiv2 < ver_pyexiv2_min):
        print 'Newer version of pyexiv2 required.'
        sys.exit(1)

    if (len(sys.argv) != 3):
        print 'Usage: ' + sys.argv[0] + ' <sourcefile> <targetfile>'
        sys.exit(1)

    # Load the image, read the metadata and extract the thumbnail data
    src_metadata = ImageMetadata(sys.argv[1])
    src_metadata.read()
    tgt_metadata = ImageMetadata(sys.argv[2])
    tgt_metadata.read()

    for groupName, tagList in copy_tags.iteritems():
        # print groupName
        # print tagList
        for i, tagName in enumerate(tagList):
            fullkey = 'Exif.' + groupName + '.' + tagName
            try: 
                tag = src_metadata[fullkey]
                print fullkey + ': ' + tag.raw_value
            except KeyError:
                print "WARNING: can't find EXIF key '" + fullkey + "'"

            tgt_metadata[fullkey] = tag

    # we're done, so write the updates to the target file (preserving
    # the file's timestamps via the 'True' parameter)
    tgt_metadata.write(True)
