-- Price Variation - product price variation over time

register datafu-pig-incubating-1.3.0.jar;
define Quantile datafu.pig.stats.StreamingQuantile('0.0','0.5','0.75','1.0');

grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray,	 price:chararray, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

g1 = FOREACH grams GENERATE LOWER(market) AS (market:chararray), LOWER(product) AS (product:chararray), price, timestamp;
g2 = FOREACH g1 GENERATE REPLACE(market, '"','') AS (market:chararray), REPLACE(product,'"','') AS (product:chararray), (float)REPLACE(price,'"','') AS (price:float), REPLACE(timestamp,'"','') AS (timestamp:chararray);
g3 = FOREACH g2 GENERATE market, product, price, CONCAT(timestamp,'000') AS (timestamp:chararray);
g4 = FOREACH g3 GENERATE market, product, price, ToDate((long)timestamp) AS (timestamp:Datetime);

re1 = FOREACH g4 GENERATE market, REGEX_EXTRACT(product, '(mdma|molly|bitcoin|bud|weed|mephedrone|speed|tramadol|kush|codezine|diazepam|buprenorphine|cocaine|suboxone|bacardi|whiskey|chiesel|diazepam|xanax|heroin|usps|xtc|ecstacy)',1) AS (product:chararray), price, timestamp;

g5 = FOREACH re1 GENERATE market, product, price, GetDay(timestamp) AS (day:int), GetMonth(timestamp) AS (month:int), GetYear(timestamp) AS (year:int);

grp1 = GROUP g5 BY (day,month,year,product);

mean1 = FOREACH grp1 GENERATE FLATTEN(group) AS (day,month,year,product), AVG($1.price) AS (mean:float);

STORE mean1 INTO 'q5_mean' USING PigStorage(',');

order1 = FOREACH grp1 { sorted = ORDER g5 BY price; GENERATE group, sorted; }
quantile1 = FOREACH order1 GENERATE FLATTEN(group) AS (day,month,year,product), Quantile( $1.price );
quantile2 = FOREACH quantile1 GENERATE day, month, year, product, $4.quantile_0_0 AS q0, $4.quantile_0_5 AS q1, $4.quantile_0_75 AS q2,  $4.quantile_1_0 AS q3;

STORE quantile2 INTO 'q5_quantile' USING PigStorage(',');

mres1 = JOIN mean1 BY (day,month,year,product), quantile2 BY (day,month,year,product);
mres2 = FOREACH mres1 GENERATE mean1::day AS day, mean1::month AS month, mean1::year AS year, mean1::product AS product, mean1::mean AS mean, quantile2::q0 AS q0, quantile2::q1 AS q1, quantile2::q2 AS q2, quantile2::q3 AS q3;

STORE mres2 INTO 'q5' USING PigStorage(',');

/*
(1,5,2014,suboxone,30.0,30.0,30.0,30.0,30.0)
(1,6,2014,bud,44.0,9.5,42.5,80.0,80.0)
(2,6,2014,bacardi,30.0,30.0,30.0,30.0,30.0)
(2,6,2014,whiskey,50.0,50.0,50.0,50.0,50.0)
(3,5,2014,weed,119.0,52.0,90.0,215.0,215.0)
(3,5,2014,speed,88.0,12.0,50.0,90.0,200.0)
(3,5,2014,mephedrone,77.0,34.0,60.0,84.0,130.0)
(4,5,2014,weed,12.0,12.0,12.0,12.0,12.0)
(8,5,2014,bitcoin,0.25,0.25,0.25,0.25,0.25)
(12,5,2014,tramadol,61.666666666666664,30.0,55.0,100.0,100.0)
(15,5,2014,xanax,40.0,40.0,40.0,40.0,40.0)
(20,5,2014,heroin,535.0,70.0,70.0,1000.0,1000.0)
(21,5,2014,mdma,300.0,200.0,200.0,400.0,400.0)
(21,5,2014,cocaine,1790.0,650.0,1500.0,3220.0,3220.0)
(22,5,2014,mdma,100.0,100.0,100.0,100.0,100.0)
(22,5,2014,cocaine,143.5,102.0,102.0,185.0,185.0)
(25,4,2014,mdma,195.0,90.0,90.0,300.0,300.0)
(25,4,2014,cocaine,196.66666666666666,70.0,120.0,400.0,400.0)
(25,5,2014,bud,223.0,130.0,200.0,225.0,360.0)
(25,5,2014,kush,312.5,225.0,225.0,400.0,400.0)
(25,5,2014,diazepam,39.666666666666664,26.0,43.0,50.0,50.0)
(25,5,2014,tramadol,80.0,60.0,60.0,100.0,100.0)
(25,5,2014,buprenorphine,85.0,50.0,50.0,120.0,120.0)
(27,5,2014,bitcoin,18.0,18.0,18.0,18.0,18.0)
(30,5,2014,kush,75.66666666666667,34.0,67.0,126.0,126.0)
*/