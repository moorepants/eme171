#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

import yaml

AUTHOR = 'Jason K. Moore'
SITENAME = 'EME 171: Analysis, Simulation and Design of Mechatronic Systems'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'America/Los_Angeles'

DEFAULT_LANG = 'en'

# This sets the default pages to be top level items.
PAGE_URL = '{slug}.html'
PAGE_SAVE_AS = '{slug}.html'
PAGE_ORDER_BY = 'sortorder'
STATIC_PATHS = ['scripts']

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = ()

# Social widget
SOCIAL = ()

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

try:
    with open('config.yml', 'r') as config_file:
        config_data = yaml.load(config_file)
except IOError:
    THEME = ''
    PLUGIN_PATHS = ''
else:
    THEME = config_data['THEME_PATH']
    PLUGIN_PATHS = config_data['PLUGIN_PATHS']

## THEME

# Alchemy theme settings
SITESUBTITLE = ''
SITEIMAGE = ''
DESCRIPTION = ''
PYGMENTS_STYLE = 'emacs'

## PLUGINS

PLUGINS = ['render_math', 'code_include']
