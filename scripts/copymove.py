#!/usr/bin/env python2
"""Move files by copying and deleting the original.

This is mainly useful for moving things that are hardlinks that you want to
break, giving an independent copy of the files.

Depends on Python 2 ond the docopt module.

Usage:
  copymove.py [options] SOURCE DEST
  copymove.py [options] -t DIRECTORY SOURCE...
  copymove.py -h | --help

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

    run(['cp', '-a', source, dest], dryrun)
    run(['rm', '-r', source], dryrun)


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
