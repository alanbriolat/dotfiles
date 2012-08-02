#!/usr/bin/env python3

"""
Probably not the ugliest or hackiest image uploader ever...

Depends on:
    ssh (for scp)
    convert (for --shadow)
    xdg-open (for --launch)

Author: Alan Briolat <alan.briolat@gmail.com>
"""

import os
import argparse
import subprocess
from datetime import datetime


def run(cmd, *args, method=subprocess.check_call, **kwargs):
    print('executing command:', cmd)
    return method(cmd, *args, **kwargs)


class Processor(object):
    def process(self, args, info):
        pass


class Renamer(Processor):
    def __init__(self, pattern):
        self.pattern = pattern

    def process(self, args, info):
        newpath = datetime.now().strftime(self.pattern)
        newpath = newpath.format(**info)
        run(['mv', info['path'], newpath])
        info['path'] = newpath
        info['file'] = os.path.basename(newpath)
        info['dir'] = os.path.dirname(newpath)
        info['ext'] = os.path.splitext(newpath)[1]


class AddShadow(Processor):
    def process(self, args, info):
        cmd = (['convert', info['path']] +
                '( +clone -background black -shadow 70x5+0+0 )'.split() +
                '+swap -background none -layers merge +repage'.split() +
                [info['path']])
        run(cmd)


class UrlGenerator(Processor):
    def __init__(self, urlpattern):
        self.urlpattern = urlpattern

    def process(self, args, info):
        info['url'] = self.urlpattern.format(**info)


class Launcher(Processor):
    def process(self, args, info):
        cmd = ['xdg-open']
        if 'url' in info:
            cmd.append(info['url'])
        else:
            cmd.append(info['path'])
        run(cmd)


class Uploader(Processor):
    def process(self, args, info):
        self.upload(args, info)

    def upload(self, args, info):
        pass

    def populate_subparser(self, parser):
        pass


class ScpUploader(Uploader):
    def populate_subparser(self, parser):
        parser.add_argument('destination', help='scp destination')
        parser.add_argument('-p', '--port', help='ssh port [default: 22]')

    def upload(self, args, info):
        dest = args.destination.rstrip('/') + '/'
        cmd = ['scp']
        if args.port:
            cmd += ['-P', args.port]
        cmd += [info['path'], dest]
        run(cmd)


UPLOADERS = [
    ('scp', 'copy files with scp', ScpUploader()),
]


parser = argparse.ArgumentParser()
parser.add_argument('-r', '--rename', help='rename file')
parser.add_argument('--shadow', action='store_true', help='add drop shadow')
parser.add_argument('--url', help='generate and open url')
parser.add_argument('--launch', action='store_true',
                    help='launch url/save location with xdg-open')
subparsers = parser.add_subparsers(help='upload method')
for name, desc, uploader in UPLOADERS:
    subparser = subparsers.add_parser(name, help=desc)
    uploader.populate_subparser(subparser)
    subparser.set_defaults(uploader=uploader)
parser.add_argument('file', help='the file to upload')

args = parser.parse_args()

print(args)


info = {
    'path': args.file,
    'file': os.path.basename(args.file),
    'dir': os.path.dirname(args.file),
    'ext': os.path.splitext(args.file)[1],
}

processors = []

if args.rename:
    processors.append(Renamer(args.rename))

if args.shadow:
    processors.append(AddShadow())

processors.append(args.uploader)

if args.url:
    processors.append(UrlGenerator(args.url))

if args.launch:
    processors.append(Launcher())


for p in processors:
    p.process(args, info)
