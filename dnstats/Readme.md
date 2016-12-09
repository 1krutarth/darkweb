This DNStats file has information regarding the live status of multiple dark net markets.

We have following information attributes:
	1. sitename
	2. rid - sitename id
	2. type of market
		* 1 = markets
		* 2 = forums
		* 3 = unknown
		* 5 = market
	3. siteup - not much use as every value is set to 1
	4. httpcode
	5. download speed
	6. total time for downloading something at above speed
	7. timestamp

Following are the set of queries that can done to dataset
	* plot site-live percentage status for every hour/month/year 
	* type of connection with the site based on download speed and total time

Files:
	* q1.pig: Count up and down frequency of sites for every year
	* q2.pig: Count up and down frequency of sites for every month
	* q3.pig: Count up and down frequency of sites for every day
	* q1 and q2 will be used to calculate site-live percentage
	* q3 will be used to plot site live percentage on a daily basis
