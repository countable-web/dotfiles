#!/usr/bin/python

import os, sys

# Gets all the jade files in /client and compiles them into a template.
if os.path.exists('%s'%sys.argv[1]):
  jadefiles = ' '.join([os.path.join(sys.argv[1],l.strip()) for l in os.popen('ls %s/*.jade'%sys.argv[1]).readlines()])
  if len(jadefiles):
    print 'clientjade %s > %s/templates.js'%(jadefiles,sys.argv[2])
    print os.popen('clientjade %s > %s/templates.js'%(jadefiles,sys.argv[2])).read()
  else:
    print "No jade files found in %s"%sys.argv[1]
else:
  print "No client jade folder. %s"%sys.argv[1]
