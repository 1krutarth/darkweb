grams = LOAD 'data/1776.csv' USING PigStorage(',') AS (hash:chararray, market:chararray, itemlink:chararray, vendor:chararray, price:float, product:chararray, description:chararray, image:chararray, timestamp:chararray, ship_from:chararray );

g1 = FOREACH grams GENERATE market, timestamp;
c1 = FOREACH g1 GENERATE market, REPLACE(timestamp,'"', '' ) AS (timestamp:chararray);
d1 = FOREACH c1 GENERATE market, CONCAT(timestamp,'000') AS (timestamp:chararray);
e1 = FOREACH d1 GENERATE market, ToDate((long)timestamp) AS (timestamp:Datetime);

e2 = FOREACH e1 GENERATE market, GetDay(timestamp) AS (day:int), GetMonth(timestamp) AS (month:int), GetYear(timestamp) AS (year:int);

grp1 = GROUP e2 BY (day,month,year);
grp2 = FOREACH grp1 GENERATE FLATTEN(group) AS (day,month,year), COUNT($1) AS (no_of_products:int);

STORE grp2 INTO 'q1' using PigStorage(',');