#!/usr/bin/env python2
import subprocess
import re
import sys


SIGNAL_MAP = {}

def populate_signal_map(force=False):
    if SIGNAL_MAP and not force:
        return
    SIGNAL_MAP.clear()
    # Get map from signal number to signal name for this system
    raw_signal_data = subprocess.check_output(['kill', '-L'])
    for number, name in re.findall(r'\s*(\d+)\s+([A-Z0-9-+]+)', raw_signal_data):
        SIGNAL_MAP[int(number)] = name

    SIGNAL_MAP['_FORMAT'] = 'SIG{{name:<{sigwidth}}} ({{number:>2}}): {{is_set}}'.format(
            sigwidth=max(len(x) for x in SIGNAL_MAP.values()))


def decode_signal_mask(mask, base=16):
    populate_signal_map()
    as_int = int(mask, base)
    as_bin = bin(as_int)
    lsb_first = reversed(as_bin[2:])
    return [{'number': i, 'name': SIGNAL_MAP.get(i, '???'), 'is_set': x == '1'}
            for i, x in enumerate(lsb_first, start=1)]


def blah(foo):
    for x in enumerate(reversed(bin(int(foo, 16))), start=1):
        print x


if __name__ == '__main__':
    for arg in sys.argv[1:]:
        print 'Mask =', arg
        for signal in decode_signal_mask(sys.argv[1]):
            print SIGNAL_MAP['_FORMAT'].format(**signal)
        print ''
