##Count up and down frequency of sites for every year

###Script: q1.pig

###Data description
* `q1_sample.txt` is the output from `data` directory
* `q1_complete.txt` is the output from data found from dnstats.
* Data Attributes:
	* First attribute: year
	* Second attribute: market
	* Third attribute: upcount - number of time sites were up in that year
	* Fourth attribute: downcount - number of time sites were down in that year