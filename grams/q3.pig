grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray, price:float, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

g1 = FOREACH grams GENERATE LOWER(vendor) AS (vendor:chararray), LOWER(product) AS (product:chararray), REPLACE(timestamp,'"','') AS (timestamp:chararray);
g2 = FOREACH g1 GENERATE vendor, product, CONCAT(timestamp,'000') AS (timestamp:chararray);
g3 = FOREACH g2 GENERATE vendor, product, ToDate((long)timestamp) AS (timestamp:Datetime);


re1 = FOREACH g3 GENERATE vendor, REGEX_EXTRACT(product, '(mdma|molly|bitcoin|bud|weed|mephedrone|speed|tramadol|kush|codezine|diazepam|buprenorphine|cocaine|suboxone|bacardi|whiskey|chiesel|diazepam|xanax|heroin|usps|xtc|ecstacy)',1) AS (product:chararray), timestamp;

d1 = FOREACH re1 GENERATE vendor, product, GetMonth(timestamp) AS (month:int), GetYear(timestamp) AS (year:int);

grp1 = GROUP d1 BY (month,year,product);
grp2 = FOREACH grp1 GENERATE FLATTEN(group) AS (month,year,product), COUNT($1) AS (no_of_vendors:int);

STORE grp2 INTO 'q3' USING PigStorage(',');

/*
(4,2014,mdma,2)
(4,2014,cocaine,3)
(5,2014,bud,5)
(5,2014,kush,5)
(5,2014,mdma,3)
(5,2014,weed,4)
(5,2014,speed,4)
(5,2014,xanax,1)
(5,2014,heroin,2)
(5,2014,bitcoin,2)
(5,2014,cocaine,5)
(5,2014,diazepam,3)
(5,2014,suboxone,1)
(5,2014,tramadol,5)
(5,2014,mephedrone,4)
(5,2014,buprenorphine,2)
(5,2014,,20)
(6,2014,bud,3)
(6,2014,bacardi,1)
(6,2014,whiskey,1)
(6,2014,,7)

*/