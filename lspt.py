#!/usr/bin/python
#
# lspt.py - list permissions tree
#
# CREATED:  a while back
# MODIFIED: 2009-08-25 20:59

import getopt
import grp
import os
import pwd
import stat
import sys
import string
from glob import glob

class Usage(Exception):
  def __init__(self, msg):
    self.msg = msg

class Lspt():
  """Usage: lspt [options] [path]
    List permissions tree.

  Options:
    -d, --depth N          only traverse N levels up the tree
                             Default: -1 (traverse to /)
    -h, --help             display this usage message
    -n, --numeric-mode     display numeric permissions
    -t, --text-mode        display text permissions (default)
  """

  def __init__(self):
    self._depth = -1
    self._modeView = "text"
    self._pad = 0
    self._leaf = None

  def lspt(self, path):
    # exit case
    if path == "":
      path = "/"

    # who owns this
    st = os.stat(path)
    mode = st[stat.ST_MODE]
    user = pwd.getpwuid(st[stat.ST_UID])[0]
    group = grp.getgrgid(st[stat.ST_GID])[0]

    owner = user + ":" + group
    if len(owner) > self._pad:
      self._pad = len(owner)

    if path != "/" and self._depth != 0:
      self._depth -= 1
      self.lspt(os.path.abspath(path).rsplit("/", 1)[0])
   
    # convert numerical mode to text if requested
    if self._modeView == "text":
      perms = ""
      for level in "USR", "GRP", "OTH":
        for perm in "R", "W", "X":
          if int(mode) & getattr(stat,"S_I"+perm+level):
            perms += perm
          else:
            perms += "-"
      mode = perms.lower()
    else:
      mode = oct(mode & 0777)[1:]

    owner = string.ljust(owner, self._pad)
    print mode, owner, os.path.abspath(path)

def main():
  lspt = Lspt()

  try:
    opts, args = getopt.gnu_getopt(sys.argv[1:], "d:hnt",
                               ["depth", "help", "numeric-mode", "text-mode"])
  except getopt.error, e:
    print "lspt: " + str(e) + ", see -h or --help for options"
    return 1

  for o, a in opts:
    if o in ("-h", "--help"):
      print Lspt.__doc__
      return 0
    elif o in ("-t", "--text-mode"):
      lspt._modeView = "text"
    elif o in ("-n", "--numeric-mode"):
      lspt._modeView = "numeric"
    elif o in ("-d", "--depth"):
      try:
        a = int(a)
        if a > 0:
          lspt._depth = a
        else:
          raise ValueError
      except ValueError:
        print "lspt: depth must be a positive integer"
        return 1

  if len(args) == 0:
    lspt._leaf = "."
  elif len(args) > 1:
    print "lspt: too many arguments"
    return 1
  else:
    if os.path.exists(args[0]):
      lspt._leaf = args[0]
    else:
      print "lspt: " + args[0] + " does not exist"
      return 1

  lspt.lspt(lspt._leaf)

if __name__ == '__main__':
  sys.exit(main())
