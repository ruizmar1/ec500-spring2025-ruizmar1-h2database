-- Copyright 2004-2025 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

SELECT EXTRACT(NANOSECOND FROM TIME '10:00:00.123456789') IS OF (INTEGER);
>> TRUE

SELECT EXTRACT(EPOCH FROM TIME '01:00:00') IS OF (NUMERIC);
>> TRUE

SELECT EXTRACT (MICROSECOND FROM TIME '10:00:00.123456789'),
    EXTRACT (MCS FROM TIMESTAMP '2015-01-01 11:22:33.987654321');
> 123456 987654
> ------ ------
> 123456 987654
> rows: 1

SELECT EXTRACT (NANOSECOND FROM TIME '10:00:00.123456789'),
    EXTRACT (NS FROM TIMESTAMP '2015-01-01 11:22:33.987654321');
> 123456789 987654321
> --------- ---------
> 123456789 987654321
> rows: 1

select EXTRACT (EPOCH from time '00:00:00');
>> 0

select EXTRACT (EPOCH from time '10:00:00');
>> 36000

select EXTRACT (EPOCH from time '10:00:00.123456');
>> 36000.123456

select EXTRACT (EPOCH from date '1970-01-01');
>> 0

select EXTRACT (EPOCH from date '2000-01-03');
>> 946857600

select EXTRACT (EPOCH from timestamp '1970-01-01 00:00:00');
>> 0

select EXTRACT (EPOCH from timestamp '1970-01-03 12:00:00.123456');
>> 216000.123456

select EXTRACT (EPOCH from timestamp '2000-01-03 12:00:00.123456');
>> 946900800.123456

select EXTRACT (EPOCH from timestamp '2500-01-03 12:00:00.654321');
>> 16725441600.654321

select EXTRACT (EPOCH from timestamp with time zone '1970-01-01 00:00:00+05');
>> -18000

select EXTRACT (EPOCH from timestamp with time zone '1970-01-03 12:00:00.123456+05');
>> 198000.123456

select EXTRACT (EPOCH from timestamp with time zone '2000-01-03 12:00:00.123456+05');
>> 946882800.123456

select extract(EPOCH from '2001-02-03 14:15:16');
>> 981209716

SELECT EXTRACT(EPOCH FROM INTERVAL '10.1' SECOND);
>> 10.1

SELECT EXTRACT(EPOCH FROM INTERVAL -'0.000001' SECOND);
>> -0.000001

SELECT EXTRACT(EPOCH FROM INTERVAL '0-1' YEAR TO MONTH);
>> 2592000

SELECT EXTRACT(EPOCH FROM INTERVAL '-0-1' YEAR TO MONTH);
>> -2592000

SELECT EXTRACT(EPOCH FROM INTERVAL '1-0' YEAR TO MONTH);
>> 31557600

SELECT EXTRACT(EPOCH FROM INTERVAL '-1-0' YEAR TO MONTH);
>> -31557600

SELECT EXTRACT(TIMEZONE_HOUR FROM TIMESTAMP WITH TIME ZONE '2010-01-02 5:00:00+07:15');
>> 7

SELECT EXTRACT(TIMEZONE_HOUR FROM TIMESTAMP WITH TIME ZONE '2010-01-02 5:00:00-08:30');
>> -8

SELECT EXTRACT(TIMEZONE_MINUTE FROM TIMESTAMP WITH TIME ZONE '2010-01-02 5:00:00+07:15');
>> 15

SELECT EXTRACT(TIMEZONE_MINUTE FROM TIMESTAMP WITH TIME ZONE '2010-01-02 5:00:00-08:30');
>> -30

SELECT EXTRACT(TIMEZONE_SECOND FROM TIMESTAMP WITH TIME ZONE '1880-01-01 10:00:00-07:52:58');
>> -58

SELECT EXTRACT(TIMEZONE_HOUR FROM TIME WITH TIME ZONE '5:00:00+07:15');
>> 7

SELECT EXTRACT(TIMEZONE_MINUTE FROM TIME WITH TIME ZONE '5:00:00+07:15');
>> 15

select extract(hour from timestamp '2001-02-03 14:15:16');
>> 14

select extract(hour from '2001-02-03 14:15:16');
>> 14

SELECT EXTRACT(YEAR FROM INTERVAL '-1' YEAR);
>> -1

SELECT EXTRACT(YEAR FROM INTERVAL '1-2' YEAR TO MONTH);
>> 1

SELECT EXTRACT(MONTH FROM INTERVAL '-1-3' YEAR TO MONTH);
>> -3

SELECT EXTRACT(MONTH FROM INTERVAL '3' MONTH);
>> 3

SELECT EXTRACT(DAY FROM INTERVAL '1100' DAY);
>> 1100

SELECT EXTRACT(DAY FROM INTERVAL '10 23' DAY TO HOUR);
>> 10

SELECT EXTRACT(DAY FROM INTERVAL '10 23:15' DAY TO MINUTE);
>> 10

SELECT EXTRACT(DAY FROM INTERVAL '10 23:15:30' DAY TO SECOND);
>> 10

SELECT EXTRACT(HOUR FROM INTERVAL '15' HOUR);
>> 15

SELECT EXTRACT(HOUR FROM INTERVAL '2 15' DAY TO HOUR);
>> 15

SELECT EXTRACT(HOUR FROM INTERVAL '2 10:30' DAY TO MINUTE);
>> 10

SELECT EXTRACT(HOUR FROM INTERVAL '2 10:30:15' DAY TO SECOND);
>> 10

SELECT EXTRACT(HOUR FROM INTERVAL '20:10' HOUR TO MINUTE);
>> 20

SELECT EXTRACT(HOUR FROM INTERVAL '20:10:22' HOUR TO SECOND);
>> 20

SELECT EXTRACT(MINUTE FROM INTERVAL '-35' MINUTE);
>> -35

SELECT EXTRACT(MINUTE FROM INTERVAL '1 20:33' DAY TO MINUTE);
>> 33

SELECT EXTRACT(MINUTE FROM INTERVAL '1 20:33:10' DAY TO SECOND);
>> 33

SELECT EXTRACT(MINUTE FROM INTERVAL '20:34' HOUR TO MINUTE);
>> 34

SELECT EXTRACT(MINUTE FROM INTERVAL '20:34:10' HOUR TO SECOND);
>> 34

SELECT EXTRACT(MINUTE FROM INTERVAL '-34:10' MINUTE TO SECOND);
>> -34

SELECT EXTRACT(SECOND FROM INTERVAL '-100' SECOND);
>> -100

SELECT EXTRACT(SECOND FROM INTERVAL '10 11:22:33' DAY TO SECOND);
>> 33

SELECT EXTRACT(SECOND FROM INTERVAL '1:2:3' HOUR TO SECOND);
>> 3

SELECT EXTRACT(SECOND FROM INTERVAL '-2:43' MINUTE TO SECOND);
>> -43

SELECT EXTRACT(SECOND FROM INTERVAL '11.123456789' SECOND);
>> 11

SELECT EXTRACT(MILLISECOND FROM INTERVAL '11.123456789' SECOND);
>> 123

SELECT EXTRACT(MICROSECOND FROM INTERVAL '11.123456789' SECOND);
>> 123456

SELECT EXTRACT(NANOSECOND FROM INTERVAL '11.123456789' SECOND);
>> 123456789

SELECT D, ISO_YEAR(D) Y1, EXTRACT(ISO_WEEK_YEAR FROM D) Y2, EXTRACT(ISO_YEAR FROM D) Y3, EXTRACT(ISOYEAR FROM D) Y4
    FROM (VALUES DATE '2017-01-01', DATE '2017-01-02') V(D);
> D          Y1   Y2   Y3   Y4
> ---------- ---- ---- ---- ----
> 2017-01-01 2016 2016 2016 2016
> 2017-01-02 2017 2017 2017 2017
> rows: 2

SELECT D, EXTRACT(ISO_DAY_OF_WEEK FROM D) D1, EXTRACT(ISODOW FROM D) D2
    FROM (VALUES DATE '2019-02-03', DATE '2019-02-04') V(D);
> D          D1 D2
> ---------- -- --
> 2019-02-03 7  7
> 2019-02-04 1  1
> rows: 2

SET MODE PostgreSQL;
> ok

SELECT D, EXTRACT(DOW FROM D) D3 FROM (VALUES DATE '2019-02-02', DATE '2019-02-03') V(D);
> D          D3
> ---------- --
> 2019-02-02 6
> 2019-02-03 0
> rows: 2

SET MODE Regular;
> ok

SELECT EXTRACT(MILLENNIUM FROM DATE '-1000-12-31');
>> -1

SELECT EXTRACT(MILLENNIUM FROM DATE '-999-01-01');
>> 0

SELECT EXTRACT(MILLENNIUM FROM DATE '0000-12-31');
>> 0

SELECT EXTRACT(MILLENNIUM FROM DATE '0001-01-01');
>> 1

SELECT EXTRACT(MILLENNIUM FROM DATE '1000-12-31');
>> 1

SELECT EXTRACT(MILLENNIUM FROM DATE '1001-01-01');
>> 2

SELECT EXTRACT(CENTURY FROM DATE '-100-12-31');
>> -1

SELECT EXTRACT(CENTURY FROM DATE '-99-01-01');
>> 0

SELECT EXTRACT(CENTURY FROM DATE '0000-12-31');
>> 0

SELECT EXTRACT(CENTURY FROM DATE '0001-01-01');
>> 1

SELECT EXTRACT(CENTURY FROM DATE '0100-12-31');
>> 1

SELECT EXTRACT(CENTURY FROM DATE '0101-01-01');
>> 2

SELECT EXTRACT(DECADE FROM DATE '-11-12-31');
>> -2

SELECT EXTRACT(DECADE FROM DATE '-10-01-01');
>> -1

SELECT EXTRACT(DECADE FROM DATE '-1-12-31');
>> -1

SELECT EXTRACT(DECADE FROM DATE '0000-01-01');
>> 0

SELECT EXTRACT(DECADE FROM DATE '0009-12-31');
>> 0

SELECT EXTRACT(DECADE FROM DATE '0010-01-01');
>> 1
