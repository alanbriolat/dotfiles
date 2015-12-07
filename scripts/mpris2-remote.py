#!/usr/bin/env python
"""
Ugly hacky glue script for controlling any MPRIS2-compliant player with
multimedia keys. Depends on the ``mpris2`` Python package.

    mpris2-remote.py (PlayPause|Stop|Next|Previous)
"""
import sys

import mpris2

# Find player
uri = next(mpris2.get_players_uri())
# Connect to player
player = mpris2.Player(dbus_interface_info={'dbus_uri': uri})
# Get method name
assert len(sys.argv) == 2, 'Usage: mpris2-remote.py <method>'
method = sys.argv[1]
assert method in {'PlayPause', 'Stop', 'Next', 'Previous'}
# Call method
getattr(player, method)()
