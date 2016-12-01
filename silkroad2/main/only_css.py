import os
import shutil

root = os.path.join( os.getcwd(), 'silkroad2' )
mov = os.path.join( os.getcwd(), 'scss' )
cntr = 0
total_files = 0

for path, subdirs, files in os.walk( root ):
	for file in files:
		if '.css' in file:
			src = os.path.join( path, file )
			dest = os.path.join( mov, path.split('/')[4]+'_'+file )
			shutil.copy2( src, dest )
			cntr = cntr + 1
	if cntr > 0:
		print( 'files moved: {}'.format( cntr ) )
		total_files += cntr
	cntr = 0
print( 'Total css files: {}'.format( total_files ) )