#Dark Web

###Live Demo here: <a href="https://10bottomsup.github.io/darkweb/index.html" target="_blank">DNM Site</a>


This project involves using parallel programming technologies like Hadoop MapReduce, Pig to generate reports from terabytes of unstructured data. It involves 85+ DNMs (Dark Net Markets) and 35+ forums crawled from Dark Web. 

###Tasks
+ Studying the article
+ Features:
	+ Geotagging Exif
		+ Markets to be considered
			+ Agora
			+ Blackbank
			+ Evolution
			+ SilkRoad 2
	+ Site live-status (DNStats, 13 million rows)
		+ Survival Analysis
			+ Site uptime(%) with time
			+ Site live status with time
	+ Item analysis (Grams - 2860 files)
		+ Items in market with time
		+ Item in demand
	+ Profile Analysis
		+ Average lifetime of profile
		+ Traffic on site based on registration, local time
		+ Profile Engagement
	+ Topic(post) Analysis
		+ Topic popularity among Profiles
		+ Topic popularity with time
		+ Most discussed topic

###Steps
+ This will charge your AWS instance, so don't keep it running. STOP it to avoid incurring any charges. Refer https://aws.amazon.com/ec2/pricing/on-demand/ for pricing.
+ Create instance with ubuntu 14.04 on AWS. Configuration:
	+ Instance Type: General Purpose, m4.xlarge(or m4.2xlarge/m4.4x.large);
	+ Storage: at least 200GiB 
+ Download all the tar files in your instance as assigned below:
	+ Alma: Agora
	+ Nikhil: Blackbank
	+ Venkatesh: Evolution
	+ Krutarth: Silk Road2 
+ To download, 
	+ visit: https://archive.org/download/dnmarchives
	+ Copy the link address of your market
	+ wget <paste-your-link>
+ To untar
	+ first execute this command (only once): sudo apt-get install xz-utils
	+ unxz <your-.xz-file>
	+ Once its unxz's, you need to untar it. Its done as below.
	+ tar -xvf <your-.tar-file>
+ Additional work (if interested)
	+ Try to understand the data and see if it can be correlated to any of the above mentioned features.


###Credits: https://www.gwern.net/Black-market%20archives

###Disclaimer:
This authors/creators of this project do not take any responsibility for any encouragement that might interest someone to operate on Dark Web. We haven't crawled data for this project. We have used data that's available on internet, as mentioned above in credits section. This project is meant to realize power of parallel programming technologies on huge unstructured data. 

###Acknowledgements
Gwern Branwen, Nicolas Christin, David Décary-Hétu, Rasmus Munksgaard Andersen, StExo, El Presidente, Anonymous, Daryl Lau, Sohhlz, Delyan Kratunov, Vince Cakic, Van Buskirk, & Whom. “Dark Net Market archives, 2011–2015”, 12 July 2015. Web. 12 September 2016. www.gwern.net/Black-market%20archives
