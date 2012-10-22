#!/usr/bin/env python2
"""Move files and symbolically link them back to their original locations.

Depends on Python 2 and the docopt module.

Usage:
  symmv.py [options] SOURCE DEST
  symmv.py [options] -t DIRECTORY SOURCE...
  symmv.py -h | --help

Options:
  -d --dry-run      Only print commands, don't run them
"""
import os
import subprocess
from docopt import docopt


def run(args, dryrun):
    """Print and run *args*, unless *dryrun* is True."""
    print(args)
    if not dryrun:
        subprocess.check_call(args)


def move_single(source, dest, dryrun):
    source = source.rstrip('/')
    dest = dest.rstrip('/')
    if os.path.isdir(dest):
        dest = os.path.join(dest, os.path.basename(source))
    if os.path.exists(dest):
        raise Exception('destination "{}" already exists'.format(dest))
    if os.path.islink(source):
        raise Exception(('source "{}" is a symbolic link - moving it will '
            'probably break it').format(source))

    run(['mv', source, dest], dryrun)
    # This method is preferred but requires a coreutils >= 8.16
    #run(['ln', '--symbolic', '--relative', dest, source], dryrun)
    # This method will have to do for old crusty OSs
    run(['ln', '--symbolic', os.path.relpath(dest, os.path.dirname(source)),
         source], dryrun)


def move_multiple(sources, dest, dryrun):
    if not os.path.isdir(dest):
        raise Exception('DIRECTORY must be a directory')
    for source in sources:
        move_single(source, dest, dryrun)


if __name__ == '__main__':
    args = docopt(__doc__)
    if args['-t']:
        move_multiple(args['SOURCE'], args['DIRECTORY'], args['--dry-run'])
    else:
        move_single(args['SOURCE'][0], args['DEST'], args['--dry-run'])
