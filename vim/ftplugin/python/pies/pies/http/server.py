from __future__ import absolute_import

from ..version_info import PY3

if PY3:
    from http.server import *
else:
    from BaseHTTPServer import *
    from CGIHTTPServer import *
    from SimpleHTTPServer import *
