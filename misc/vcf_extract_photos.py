#!/usr/bin/env python

"""Extract photos from all .VCF files in a given directory."""

import sys
import argparse
import os.path
import vobject


def process_vcf_file(pathname):
    """Process a VCF file (or all in a directory)."""
    outfname = os.path.splitext(pathname)[0]
    with open(pathname, 'r') as vcf_file:
        vcf_string = vcf_file.read()
        vcard = vobject.readOne(vcf_string)
        print("Processing '%s'..." % vcard.fn.value)
        print("  - UID: %s" % vcard.uid.value)
        if 'photo' not in vcard.contents:
            print("NO PHOTO in file '%s'!" % pathname)
            return
        photo_type = vcard.photo.params['TYPE'][0].lower()
        outfname += "." + photo_type
        print("  - type: %s" % photo_type)
        if os.path.exists(outfname):
            print("NOT overwriting file '%s'!" % outfname)
            return
        print("  - writing photo to file: %s" % outfname)
        with open(outfname, 'wb') as fout:
            fout.write(vcard.photo.value)


def parse_arguments():
    """Parse commandline arguments."""
    argparser = argparse.ArgumentParser(description=__doc__)
    add = argparser.add_argument
    add('--vcf', required=True,
        help='VCF file to extract photo from.')
    add('-v', '--verbosity', dest='verbosity',
        action='count', default=0)
    try:
        args = argparser.parse_args()
    except IOError as err:
        argparser.error(str(err))
    return args


def main():
    """Parse commandline arguments and run parser."""
    args = parse_arguments()
    process_vcf_file(args.vcf)
    print("DONE.\n")


if __name__ == "__main__":
    sys.exit(main())
