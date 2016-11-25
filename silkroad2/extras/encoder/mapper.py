import os
import re
import sys

for linex in sys.stdin:
	lines = linex.split( '\n' )
	tags = list()
	for line in lines:
		if 'background' in line:
			result = re.search( ",(.*)'", line )
			tags.append( result.group(1) )
		elif 'content' in line:
			result = re.search( ",(.*)", line )
			tags.append( result.group(1) )

	if tags:
		print( '\n'.join(tags) )