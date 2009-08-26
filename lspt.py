#!/usr/bin/python
#
# lspt.py - list permissions tree
#
# CREATED:  a while back
# MODIFIED: 2009-08-26 09:49

"""Usage: lspt [options] [path]

Options:
    -d, --depth N          only traverse N levels up the tree
                             Default: -1 (traverse to /)
    -h, --help             display this usage message
    -n, --numeric-mode     display numeric permissions
    -t, --text-mode        display text permissions (default)"""

import grp
import os
import pwd
import stat
import sys
from optparse import OptionParser

class LSPTree():
    """ LSPTree class, to be extended in the future """

    def __init__(self, opts, args):
        
        if opts.help:
            print __doc__
            sys.exit()

        self.depth = opts.depth
        self.text_mode = opts.text_mode
        self.pad = 0

        if len(args) == 0:
            self.pwd = "."
        elif len(args) > 1:
            print "lspt: too many arguments"
            sys.exit()
        else:
            if os.path.exists(args[0]):
                self.pwd = args[0]
            else:
                print "lspt: " + args[0] + " does not exist"
                sys.exit()

    def run(self):
        """Recursive method that does the work """
        # exit case
        path = self.pwd
        if path == "":
            path = "/"

        # who owns this
        stats = os.stat(path)
        mode = stats[stat.ST_MODE]
        user = pwd.getpwuid(stats[stat.ST_UID])[0]
        group = grp.getgrgid(stats[stat.ST_GID])[0]

        owner = user + ":" + group
        if len(owner) > self.pad:
            self.pad = len(owner)

        if path != "/" and self.depth != 0:
            self.depth -= 1
            self.pwd = os.path.abspath(path).rsplit("/", 1)[0]
            self.run()
     
        # convert numerical mode to text if requested
        if self.text_mode:
            perms = ""
            for level in "USR", "GRP", "OTH":
                for perm in "R", "W", "X":
                    if int(mode) & getattr(stat, "S_I" + perm + level):
                        perms += perm
                    else:
                        perms += "-"
            mode = perms.lower()
        else:
            mode = oct(mode & 0777)[1:]

        owner = str.ljust(owner, self.pad)
        print mode, owner, os.path.abspath(path)


if __name__ == '__main__':
    
    PARSER = OptionParser(version="%prog 2.0.0", conflict_handler="resolve")
    PARSER.add_option('-d', '--depth', type='int', action='store', default=-1)
    PARSER.add_option('-h', '--help', action='store_true')
    PARSER.add_option('-n', '--numeric-mode', action='store_false', 
                      dest='text_mode')
    PARSER.add_option('-t', '--text-mode', action='store_true')

    LSPTree(*PARSER.parse_args()).run()
