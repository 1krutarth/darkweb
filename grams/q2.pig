grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray, price:float, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

a1 = FOREACH grams GENERATE REPLACE(market, '"', '') AS (market:chararray), REPLACE(vendor,'"','') AS (vendor:chararray);

-- remove market from b1 and b2 if you want results across all markets
b1 = GROUP a1 BY (vendor,market);
b2 = FOREACH b1 GENERATE flatten(group) AS (vendor,market), COUNT($1) AS (no_of_markets:int);

STORE b2 INTO 'q2' using PigStorage(',');