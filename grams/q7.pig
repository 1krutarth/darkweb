-- Operations Frequency & Location from market

grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray,	 price:chararray, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

g1 = FOREACH grams GENERATE LOWER(market) as market, LOWER(ship_from) as ship_from;
g2 = FOREACH g1 GENERATE REPLACE(market,'"','') AS market, REPLACE(ship_from,'"','') AS ship_from;

grp1 = GROUP g2 BY (market, ship_from);

mres1 = FOREACH grp1 GENERATE FLATTEN(group) AS (market,ship_from), COUNT($1) AS (frequency:int);

STORE mres1 INTO 'q7' USING PigStorage(',');

/*
(1776,italy,2)
(1776,canada,8)
(1776,sweden,1)
(1776,armenia,1)
(1776,austria,1)
(1776,hungary,15)
(1776,worldwide,4)
(1776,undeclared,5)
(1776,united states,21)
(1776,united kingdom,25)
*/