--variation of product price for a vendor over time in a market

grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray,	 price:chararray, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

g1 = FOREACH grams GENERATE REPLACE(market,'"','') AS market, REPLACE(vendor,'"','') AS vendor, REPLACE(product,'"','') AS product, (float)REPLACE(price,'"','') AS (price:float), REPLACE(timestamp,'"','') AS timestamp;
g2 = FOREACH g1 GENERATE LOWER(market) as market, LOWER(vendor) AS vendor, LOWER(product) AS product, price, CONCAT(timestamp,'000') AS timestamp;
g3 = FOREACH g2 GENERATE market, vendor, product, price, ToDate((long)timestamp) AS (timestamp:Datetime);

re1 = FOREACH g3 GENERATE market, vendor, REGEX_EXTRACT(product, '(mdma|molly|bitcoin|bud|weed|mephedrone|speed|tramadol|kush|codezine|diazepam|buprenorphine|cocaine|suboxone|bacardi|whiskey|chiesel|diazepam|xanax|heroin|usps|xtc|ecstacy)',1) AS (product:chararray), price, timestamp;

g5 = FOREACH re1 GENERATE market, vendor, product, price, GetMonth(timestamp) AS (month:int), GetYear(timestamp) AS (year:int);

grp1 = GROUP g5 BY (month,year,market,vendor,product);

mres1 = FOREACH grp1 GENERATE FLATTEN(group) AS (month,year,market,vendor,product), FLATTEN(BagToTuple($1.price)) AS prices;

STORE mres1 INTO 'q6' USING PigStorage(',');

/*
(4,2014,1776,sevpee911,mdma,(300.0,90.0))
(4,2014,1776,sevpee911,cocaine,(70.0,120.0,400.0))
(5,2014,1776,tom,,(1.0))
(5,2014,1776,acab23,,(50.0))
(5,2014,1776,maxmax,bitcoin,(18.0))
(5,2014,1776,maxmax,,(25.0,50.0,50.0,45.0))
(5,2014,1776,nigger,,(25.0))
(5,2014,1776,bcdirect,bud,(225.0,130.0,200.0,200.0,360.0))
(5,2014,1776,bcdirect,kush,(400.0,225.0))
(5,2014,1776,bcdirect,,(225.0))
(5,2014,1776,butyrfent,,(80.0))
(5,2014,1776,dealer007,heroin,(1000.0,70.0))
(5,2014,1776,pharmaguy,diazepam,(50.0,43.0,26.0))
(5,2014,1776,pharmaguy,tramadol,(100.0,60.0))
(5,2014,1776,pharmaguy,buprenorphine,(120.0,50.0))
(5,2014,1776,pharmaguy,,(70.0,40.0,68.0,50.0,60.0))
(5,2014,1776,sevpee911,suboxone,(30.0))
(5,2014,1776,ukconnect,mdma,(100.0,200.0,400.0))
(5,2014,1776,ukconnect,cocaine,(650.0,3220.0,1500.0))
(5,2014,1776,atheist666,bitcoin,(0.25))
(5,2014,1776,brucewillix,weed,(52.0,90.0,215.0,12.0))
(5,2014,1776,brucewillix,speed,(12.0,50.0,200.0,90.0))
(5,2014,1776,brucewillix,tramadol,(100.0,55.0,30.0))
(5,2014,1776,brucewillix,mephedrone,(84.0,34.0,60.0,130.0))
(5,2014,1776,mitosis2020,,(25.0))
(5,2014,1776,speakeasyuk,cocaine,(185.0,102.0))
(5,2014,1776,lawnmowerman,kush,(34.0,67.0,126.0))
(5,2014,1776,lawnmowerman,,(228.0,126.0,67.0,34.0))
(5,2014,1776,school_supplies,xanax,(40.0))
(5,2014,1776,school_supplies,,(40.0))
(6,2014,1776,ketaway,,(500.0,177.0))
(6,2014,1776,drice2020,bud,(9.5,80.0,42.5))
(6,2014,1776,thisbuds4u,bacardi,(30.0))
(6,2014,1776,thisbuds4u,whiskey,(50.0))
(6,2014,1776,thisbuds4u,,(50.0,25.0,40.0))
(6,2014,1776,libertyorhemp,,(20.0,35.0))

*/