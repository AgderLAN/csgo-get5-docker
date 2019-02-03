#!/usr/bin/python

activate_this = '/app/venv/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))

import sys
import logging
logging.basicConfig(stream=sys.stderr)

folder = "/app/"
if not folder in sys.path:
    sys.path.insert(0, folder)
sys.path.insert(0,"")

from get5 import app as application
import get5
get5.register_blueprints()