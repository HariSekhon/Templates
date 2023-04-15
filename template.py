#!/usr/bin/env python3
#  coding=utf-8
#  [% VIM_TAGS %]
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2008-10-20 16:18:55 +0100 (Mon, 20 Oct 2008) %]
#
#  [% URL %]
#
#  [% LICENSE %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

"""

TODO

"""

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

#import logging
import os
#import re
import sys
#import time
import traceback
#try:
#    from bs4 import BeautifulSoup
#except ImportError:
#    print(traceback.format_exc(), end='')
#    sys.exit(4)
srcdir = os.path.abspath(os.path.dirname(__file__))
libdir = os.path.join(srcdir, 'pylib')
sys.path.append(libdir)
try:
    # pylint: disable=wrong-import-position
    from harisekhon.utils import log
    #from harisekhon.utils import CriticalError, UnknownError
    from harisekhon.utils import validate_host, validate_port, validate_user, validate_password
    from harisekhon.utils import isStr
    from harisekhon import CLI
    from harisekhon import RestNagiosPlugin
except ImportError as _:
    print(traceback.format_exc(), end='')
    sys.exit(4)

__author__ = 'Hari Sekhon'
__version__ = '0.1'


class [% NAME %](RestNagiosPlugin):

    def __init__(self):
        # Python 2.x
        super([% NAME %], self).__init__()
        # Python 3.x
        # super().__init__()
        #self.host = None
        #self.port = None
        #self.user = None
        #self.password = None
        #self.protocol = 'http'
        #self.request = RequestHandler()
        self.name =
        self.default_port = 80
        self.path = '/'
        #self.auth = False
        self.json = True
        self.msg = 'Msg not defined yet'

    def add_options(self):
        super([% NAME %], self).add_options()
        # TODO: fill in hostoption name and default port
        #self.add_hostoption(name='', default_host='localhost', default_port=80)
        #self.add_useroption(name='', default_user='admin')
        #self.add_opt('-S', '--ssl', action='store_true', help='Use SSL')
        #self.add_opt('-f', '--file', dest='file', metavar='<file>',
        #             help='Input file')

    def process_options(self):
        super([% NAME %], self).process_options()
        #self.no_args()
        #self.host = self.get_opt('host')
        #self.port = self.get_opt('port')
        #self.user = self.get_opt('user')
        #self.password = self.get_opt('password')
        #validate_host(self.host)
        #validate_port(self.port)
        #validate_user(self.user)
        #validate_password(self.password)
        #if self.get_opt('ssl'):
        #    self.protocol = 'https'
        #filename = self.get_opt('file')
        #if not filename:
        #    self.usage('--file not defined')

#    def run(self):
#        url = '{protocol}://{host}:{port}/...'.format(protocol=self.protocol, host=self.host, port=self.port)
#        start_time = time.time()
#        req = self.request.get(url)
#        query_time = time.time() - start_time
#        soup = BeautifulSoup(req.content, 'html.parser')
#        if log.isEnabledFor(logging.DEBUG):
#            log.debug("BeautifulSoup prettified:\n{0}\n{1}".format(soup.prettify(), '='*80))
#        # TODO: XXX: soup.find() can return None - do not chain calls - must test each call 'is not None'
#        # link = soup.find('p')[3]
#        # link = soup.find('th', text='Uptime:')
#        # link = soup.find_next_sibling('th', text='Uptime:')
#
#        # link = soup.find('th', text=re.compile('Uptime:?', re.I))
#        # if link is None:
#        #     raise UnknownError('failed to find tag')
#        # link = link.find_next_sibling()
#        # if link is None:
#        #     raise UnknownError('failed to find tag (next sibling tag not found)')
#        # _ = link.get_text()
#        # shorter to just catch NoneType attribute error when tag not found and returns None
#        try:
#            uptime = soup.find('th', text=re.compile('Uptime:?', re.I)).find_next_sibling().get_text()
#            version = soup.find('th', text=re.compile('Version:?', re.I)).find_next_sibling().get_text()
#        except (AttributeError, TypeError):
#            #raise UnknownError('failed to find parse output')
#            qquit('UNKNOWN', 'failed to parse output')
#        if not _ or not isStr(_) or not re.search(r'...', _):
#            #raise UnknownError('format not recognized: {0}'.format(_))
#            qquit('UNKNOWN', 'format not recognized: {0}'.format(_))
#        self.msg += ' | query_time={0:f}s'.format(query_time)

    def parse_json(self, json_data):
        _ = json_data['beans'][0]


if __name__ == '__main__':
    [% NAME %]().main()
