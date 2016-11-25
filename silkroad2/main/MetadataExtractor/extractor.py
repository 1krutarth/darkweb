import exifread
import os

def get_value( tags, key ):
	if key in tags:
		return tags.get( key )
	return None

def convert_values( value ):
	d = float(value.values[0].num) / float(value.values[0].den)
	m = float(value.values[1].num) / float(value.values[1].den)
	s = float(value.values[2].num) / float(value.values[2].den)

	return d + (m / 60.0) + (s / 3600.0)

def main():
	os.chdir( 'tmp/' )
	files = os.listdir('.')
	coord = list()

	for file in files:
		f = open( file, 'rb' )
		tags = exifread.process_file(f)
		glat = get_value( tags, 'GPS GPSLatitude' )
		glat_dir = get_value( tags, 'GPS GPSLatitudeRef' )
		glg = get_value( tags, 'GPS GPSLongitude' )
		glg_dir = get_value( tags, 'GPS GPSLongitudeRef' )

		if glat:
			lat = convert_values( glat )
			lg = convert_values( glg )
			if glat_dir.values[0] != 'N':
				lat = 0 - lat
			if glg_dir.values[0] != 'E':
				lg = 0 - lg

			print '{} {}, {} {}'.format( lat, glat_dir, lg, glg_dir )

			# coord.append( [ glat, glat_dir, glg, glg_dir ] )
		# print '{} {}, {} {}'.format( glat, glat_dir, glg, glg_dir )

if __name__ == '__main__':
	main()