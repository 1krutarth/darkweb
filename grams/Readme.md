Grams contains information crawled/API fetched from multiple markets. 

###Information attributes:
* hash
* market name
* item link
* vendor name
* price
* name
* description
* image link
* add time
* ship from

###Queries
* Market popularity - number of products in market with time
* Vendor popularity - number of products sold by a particular vendor in a market and across all markets
* Product-vendor popularity - number of vendors having product with time
* variation of product price over time ( mean, quartiles )
* variation of mean product price over market with time ( 3 dim on 2d graph )
* variation of product price for a vendor over time
* locations (and count) of operations (based on ship_from data)

###Products considered
* MDMA / Molly
* Ketamine
* Bitcoin
* Bud
* Weed
* Mephedrone
* Speed
* Tramadol
* Kush
* Codeine
* Diazepam
* Buprenorphine
* Cocaine
* Suboxone
* Bacardi
* Whiskey
* Chiesel
* Diazepam
* Xanax
* Heroin
* USPS
* XTC

###Files
* `q1.pig`: Market Popularity with time (daily/monthly/yearly)
* `q2.pig`: Vendor Popularity
* `q3.pig`: Product-vendor popularity with time (monthly)
* `q5.pig`: Price Variation - product price variation over time
