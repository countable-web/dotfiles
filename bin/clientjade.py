#!/usr/bin/python

import os, sys
# Gets all the jade files in /client and compiles them into a template.
if os.path.exists('%s/client'%sys.argv[1]):
  jadefiles = ' '.join([os.path.join(sys.argv[1],'client',l.strip()) for l in os.popen('ls %s/client/'%sys.argv[1]).readlines()])
  if len(jadefiles):
    print 'clientjade %s > %s/template.js'%(jadefiles,sys.argv[1])
    print os.popen('clientjade %s > %s/public/clientjade.js'%(jadefiles,sys.argv[1])).read()
else:
  print "No client jade folder."
