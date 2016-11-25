# Steps
# 1. For every file in the data folder, 
# 	extract base64 encoded images - mapper
# 	write base64 encoded images to single file - reducer
# 2. Write a Java program to read N lines from file per mapper and do the following:
# 	convert base64 encoded image to jpg file - mapper
# 	use the file to extract metadata - mapper
# 	write the metadata out - mapper
# 	write metadata to a file - reducer

import os
import re

class AnalyzeFile:
	def __init__( self, filename ):
		self.name = filename
		self.handler = open( self.name, 'rb' )
		self.text = self.handler.read()
		self._tokenize_contents()

	def _tokenize_contents( self ):
		self.tokens = self.text.split( '\n' )
		self.tags = list()
		for token in self.tokens:
			if 'background' in token:
				self.result = re.search( ",(.*)'", token )
				self.tags.append( self.result.group(1) )

			elif 'content' in token:
				self.result = re.search( ",(.*)", token )
				self.tags.append( self.result.group(1))

	def get_encoded_images( self ):
		return [ i for i in self.tags ]


def main():
	HOME_DIR = os.getcwd()
	DATA_DIR = '{}/data'.format( HOME_DIR )

	DATA_FILES = os.listdir( DATA_DIR )

	os.chdir( DATA_DIR )
	for file in DATA_FILES:
		print 'Considering file: {}'.format( file[0:25] + '...' )
		af = AnalyzeFile( file )
		image_tokens = af.get_encoded_images()
		print len( image_tokens )
		for it in image_tokens:
			print it[:15] + '...'

if __name__ == '__main__':
	main()