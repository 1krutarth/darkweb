dnsdata = LOAD 'data' USING PigStorage(',') as ( id:long, sitename:chararray, rid:chararray, type:chararray, siteup:chararray, httpcode:chararray, speed:chararray, tot_time:chararray, timestamp:chararray );

d1 = FOREACH dnsdata GENERATE REPLACE(sitename,'"','') AS sitename, REPLACE(httpcode,'"','') AS httpcode, REPLACE(timestamp,'"','') AS timestamp;

dns = FOREACH d1 GENERATE sitename, httpcode, ToDate( timestamp, 'yyyy-MM-dd HH:mm:ss' ) as (timestamp:Datetime);

s3 = FOREACH dns GENERATE sitename, httpcode, GetYear( timestamp ) as (year:int);
s31 = FOREACH s3 GENERATE sitename, (int)httpcode AS (httpcode:int), year;

s3_200 = FILTER s31 BY httpcode == 200;
s3_x200 = FILTER s31 BY httpcode != 200;

sub_200 = foreach s3_200 generate sitename, year;
grp_200 = group sub_200 by ( year, sitename );
grp_cnt_200 = foreach grp_200 generate flatten(group) as (year,sitename), COUNT($1) as (upcount:int);

sub_x200 = foreach s3_x200 generate sitename, year;
grp_x200 = group sub_x200 by ( year, sitename );
grp_cnt_x200 = foreach grp_x200 generate flatten(group) as (year,sitename), COUNT($1) as (downcount:int);

join1 = JOIN grp_cnt_200 BY (year, sitename), grp_cnt_x200 BY (year,sitename);

mres = foreach join1 generate grp_cnt_200::year ,grp_cnt_200::sitename as (sitename:chararray), grp_cnt_200::upcount as (upcount:int), grp_cnt_x200::downcount as (downcount:int);

store mres into 'q1' using PigStorage(',');