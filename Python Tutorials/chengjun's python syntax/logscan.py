#!/usr/bin/python
import sys
from optparse import OptionParser
class LogProcessor(object):
    def __init__(self, call_chain=None):
        if call_chain is None:
            call_chain = []
            self._call_chain = call_chain
    def split(self, line):
        parts = line.split()
        return {
            'size': 0 if parts[9] == '-' else int(parts[9]),
            'file_requested': parts[6]
            }
    def parse(self, handle):
        for line in stream:
            fields = self.split(line)
            for func in self._call_chain:
                func(fields)
class MaxSizeHandler(object):
    def __init__(self, size):
        self.size = size

    def process(self, fields):
        if fields['size'] > self.size:
            print >>sys.stderr, \
                  'Warning: %s exceeeds %d bytes (%d)!' % \
                  (fields['file_requested'], self.size,
                  fields['size'])
        if __name__ == '__main__':
            parser = OptionParser()
            parser.add_option('-s', '--size', dest="size",
                              help="Maximum File Size Allowed",
                              default=0, type="int")
            opts,args = parser.parse_args()
            call_chain = []
            size_check = MaxSizeHandler(opts.size)
            call_chain.append(size_check.process)
            processor = LogProcessor(call_chain)
            processor.parse(sys.stdin)
