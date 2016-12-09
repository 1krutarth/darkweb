dnsdata = LOAD '/home/krutarth/Documents/study/darkweb/dnstats/data/sample.csv' USING PigStorage(',') as ( id:long, sitename:chararray, rid:int, type:int, siteup:int, httpcode:int, speed:long, tot_time:float, timestamp:chararray );

dns = FOREACH dnsdata GENERATE sitename, httpcode, ToDate( timestamp, 'yyyy-MM-dd HH:mm:ss' ) as (timestamp:Datetime);

s3 = FOREACH dns GENERATE sitename, httpcode, GetDay(timestamp) as (day:int), GetMonth(timestamp) as (month:int), GetYear( timestamp ) as (year:int);
s3_200 = FILTER s3 BY httpcode == 200;
s3_x200 = FILTER s3 BY httpcode != 200;

sub_200 = foreach s3_200 generate sitename, day, month, year;
grp_200 = group sub_200 by (day,month,year,sitename);
grp_cnt_200 = foreach grp_200 generate flatten(group) as (day,month,year,sitename), COUNT($1) as (upcount:int);

sub_x200 = foreach s3_x200 generate sitename, day, month, year;
grp_x200 = group sub_x200 by ( day, month, year, sitename );
grp_cnt_x200 = foreach grp_x200 generate flatten(group) as (day, month,year,sitename), COUNT($1) as (downcount:int);

join1 = JOIN grp_cnt_200 BY (day,month,year,sitename), grp_cnt_x200 BY (day,month,year,sitename);

mres = foreach join1 generate grp_cnt_200::day, grp_cnt_200::month, grp_cnt_200::year ,grp_cnt_200::sitename as (sitename:chararray), grp_cnt_200::upcount as (upcount:int), grp_cnt_x200::downcount as (downcount:int);

store mres into 'q3' using PigStorage(',');