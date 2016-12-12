In order to run the program, some installations needs to be carried out.

0. Setting up multi-node cluster is same as the one was setup for programming assignment.
1. To install requirements to setup multi-node cluster, please refer InstallationInstructions.txt
2. To setup multi-node cluster along with the settings, please refer multi-cluster.settings
3. To run the pig scripts in 'dnstats' and 'grams' folder, please cd into the respective directory and the scripts like (for instance):
	a. On local: pig -x local q1.pig
	b. On mapreduce: pig -x mapreduce q1.pig
	c. You will see the results in q1 folder in the same directory
	d. For reference, I have also added sample and complete (i.e. from real dataset) in the folder.
		i. in dnstats, for instance, q1_sample.txt are results from sample files (data directory) and q1_complete from real dataset
		ii. in grams, for instance, sample output are commented in the script and q1_mr.txt/q1_mr_f.txt are the outputs coming from real datasets. However, I have removed noise from the datasets by running some on-the-go R and Python scripts.
4. To run silkroad2, 
	a. Extracting geotags is a two step process, 
		i. extract base64 encoded image from unstructured data and 
		ii. use encoded image to decode it and extract geotags from it.
	b. Change paths accordingly
	c. hadoop jar metadata.jar metadata_test.Base64Extractor /input-path /output-dir
	d. Once you get the results, you use the results 'part-r-00000' as input for next program.
	e. hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-2.7.3.jar -file /home/ubuntu/mapper.py -mapper "mapper.py" -file /home/ubuntu/reducer.py -reducer "reducer.py" -input /user/ubuntu/input/* -output /user/ubuntu/op1