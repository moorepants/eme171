#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

import os
import sys
sys.path.append(os.curdir)
from pelicanconf import *

THEME = "pelican-alchemy/alchemy"
PLUGIN_PATHS = "pelican-plugins"

RELATIVE_URLS = False

if 'TRAVIS_TAG' in os.environ and os.environ.get('TRAVIS_TAG') is not '':
    TAG_DIR = '/' + os.environ.get('TRAVIS_TAG')
else:
    TAG_DIR = ''

SITEURL = 'https://moorepants.github.io/eme171{}'.format(TAG_DIR)

FEED_ALL_ATOM = 'feeds/all.atom.xml'
CATEGORY_FEED_ATOM = 'feeds/{slug}.atom.xml'

DELETE_OUTPUT_DIRECTORY = True

# Following items are often useful when publishing

#DISQUS_SITENAME = ""
GOOGLE_ANALYTICS = "UA-15966419-8"
