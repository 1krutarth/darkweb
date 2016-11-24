## Running the program on sample dataset (folder: `data`)
1. `hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.7.3.jar -mapper 'python mapper.py' -reducer 'python reducer.py' -input 'silkroad2/data/*' -output 'silkroad2/output'`
2. You will see the output in `output` directory under `silkroad2` directory.
3. As reducer will add `\t\n` for entries that didn't have encoded image string, make sure that you remove them. Code snippet is below:

	```
	f = open( 'part-00000', 'rb' )
	t = f.readlines()
	f.close()
	c = list()
	for tx in t:
		if tx == '\t\n':
			continue
		else:
			# removing appending `\t\n`
			c.append( tx.replace( '\t\n', '') )

	# c has the base64 encoded image.
	print( len( c ) ) # This will be 83 for the given snapshot of data
	```
4. Above snippet has to be taken into consideration whenever you use this file further.
5. In order to convert base64 encoded image to jpg image, follow below steps (pseudo-code):
	1. `text := base64_text`
	2. `id := len(text) - ( len(text)%4 if len(text)%4 else 4 )`
	3. `text_formatted := text[ 0:id ].decode( 'base64' )`
	4. ```with open( 'image2save.jpg', 'wb' ) as f:
			f.write( text_formatted )
		```
	5. Heres the jpg file created, which can be further used to extract meta information