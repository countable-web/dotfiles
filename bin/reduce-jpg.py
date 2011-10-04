#!/usr/bin/python
import sys,os
print "reducing",sys.argv[1:]
for f in sys.argv[1:]:
        print 'reduceing',f
	print os.popen("mv %s %s.bak"%(f,f)).read()
	print os.popen("jpegtran -copy none -optimize -perfect %s.bak > %s"%(f,f)).read()
 

