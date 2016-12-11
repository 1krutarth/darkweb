tag = '"hash","market_name","item_link","vendor_name","price","name","description","image_link","add_time","ship_from",'
for root, dir, files in os.walk('.'):
	for file in files:
		with open( os.path.join(root,file), 'rb' ) as f:
			for line in f:
				if tag in line:
					break
				else:
					print '###' + os.path.join(root,file)
					break

file = 'q2_mr.txt'
res = list()
with open(file,'rb') as fp:
	for line in fp:
		token = line.split(',')
		if token[0]=='':
			pass
		elif len(token[0].split()) > 2:
			pass
		elif len(token[1].split()) > 2:
			pass
		elif token[0].isdigit():
			pass
		else:
			res.append( ','.join(token) )

with open( 'q2_mr_f.txt', 'wb' ) as fp:
	for r in res:
		fp.write( r )


file = 'q3_mr.txt'
res = list()
with open( file, 'rb' ) as fp:
	for line in fp:
		if line.split(',')[0] == '':
			pass
		else:
			res.append( line )

with open( 'q3_mr_f.txt', 'wb' ) as fp:
	for r in res:
		fp.write( r )


file = 'q5_mean_mr.txt'
res = list()
with open( file, 'rb' ) as fp:
	for line in fp:
		t = line.split(',')
		if t[0] == '':
			pass
		elif t[1] == '':
			pass
		elif t[2] == '':
			pass
		elif t[3] == '':
			pass
		elif t[4] == '':
			pass
		else:
			res.append( line )

with open( 'q5_mr_f.txt', 'wb' ) as fp:
	for r in res:
		fp.write( r )


file = 'q7_mr.txt'
res = list()
with open( file, 'rb' ) as fp:
	for line in fp:
		t = line.split(',')
		if t[0].isdigit() or t[1].isdigit():
			pass
		elif t[0] == '' or t[1]=='':
			pass
		elif len(t[0].split()) > 3:
			pass
		else:
			res.append( line )

with open( 'q7_mr_f.txt', 'wb' ) as fp:
	for r in res:
		fp.write( r )
