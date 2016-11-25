import sys
import exifread
from random import randint

def get_value( tags, key ):
	if key in tags:
		return tags.get( key )
	return None

def convert_values( value ):
	d = float(value.values[0].num) / float(value.values[0].den)
	m = float(value.values[1].num) / float(value.values[1].den)
	s = float(value.values[2].num) / float(value.values[2].den)

	return d + (m / 60.0) + (s / 3600.0)


for line in sys.stdin:
	b64img = line.split( '\t' )[1]
	b64img = b64img[:-1]
	blen = len(b64img)

	_id = blen - ( blen%4 if blen%4 else 4 )
	imgtxt = b64img[:_id].decode( 'base64' )
	fname = 'tmp/img2save-' + str(randint(0,1000)) +'.jpg'
	# fname = 'img2save.jpg'
	with open( fname, 'wb' ) as f:
		f.write( imgtxt )

	f = open( fname, 'rb' )
	try:
		tags = exifread.process_file( f )

		dlat = get_value( tags, 'GPS GPSLatitude' )
		dlat_dir = get_value( tags, 'GPS GPSLatitudeRef' )
		dlg = get_value( tags, 'GPS GPSLongitude' )
		dlg_dir = get_value( tags, 'GPS GPSLongitudeRef' )

		# if dlat and dlat_dir and dlg and dlg_dir:
		lat = None
		lg = None
		if dlat:
			lat = convert_values( dlat )
			if dlat_dir.values[0] != 'N':
				lat = 0 - lat

			lg = convert_values( dlg )
			if dlg_dir.values[0] != 'E':
				lg = 0 - lg

			print '{} {}, {} {}'.format( lat, dlat_dir, lg, dlg_dir )
	except Exception as e:
		pass