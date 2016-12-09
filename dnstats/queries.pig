1. plot site-live percentage status for every hour/month/year 

-- Load data from file
dnsdata = LOAD '/home/krutarth/Documents/study/darkweb/dnstats/data/sample.csv' USING PigStorage(',') as ( id:long, sitename:chararray, rid:int, type:int, siteup:int, httpcode:int, speed:long, tot_time:float, timestamp:chararray );

-- get unique httpcodes
hcodes = FOREACH dnsdata GENERATE httpcode;
uhcodes = DISTINCT hcodes;
dump uhcodes;
-- output: 0,200,301,302,403,404,429,500,502,503,504

/*
* Plot site live percentage status for every year
*/

dnsdata = LOAD '/home/krutarth/Documents/study/darkweb/dnstats/data/sample.csv' USING PigStorage(',') as ( id:long, sitename:chararray, rid:int, type:int, siteup:int, httpcode:int, speed:long, tot_time:float, timestamp:chararray );

dns = FOREACH dnsdata GENERATE sitename, httpcode, ToDate( timestamp, 'yyyy-MM-dd HH:mm:ss' ) as (timestamp:Datetime);

s3 = FOREACH dns GENERATE sitename, httpcode, GetYear( timestamp ) as (year:int);
s3_200 = FILTER s3 BY httpcode == 200;
s3_x200 = FILTER s3 BY httpcode != 200;

sub_200 = foreach s3_200 generate sitename, year;
grp_200 = group sub_200 by ( year, sitename );
grp_cnt_200 = foreach grp_200 generate flatten(group) as (year,sitename), COUNT($1) as (upcount:int);

sub_x200 = foreach s3_x200 generate sitename, year;
grp_x200 = group sub_x200 by ( year, sitename );
grp_cnt_x200 = foreach grp_x200 generate flatten(group) as (year,sitename), COUNT($1) as (downcount:int);

join1 = JOIN grp_cnt_200 BY (year, sitename), grp_cnt_x200 BY (year,sitename);

mres = foreach join1 generate grp_cnt_200::sitename as (sitename:chararray), grp_cnt_200::upcount as (upcount:int), grp_cnt_x200::downcount as (downcount:int);

r = foreach mres generate sitename, downcount as (down:chararray), upcount as (up:chararray);

mres1 = foreach mres generate sitename, upcount, upcount+downcount as (total:int);
mres2 = foreach mres1 generate sitename, upcount/total as (live_percent:float);
