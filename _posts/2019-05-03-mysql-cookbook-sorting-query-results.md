---
layout: post
title: MySQL Cookbook Chapter
subtitle: Sorting Query Results
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/mysql.png
share-img: /assets/img/path.jpg
tags: [ruby]
author: kieetnvt
---

# Sorting Query Results

This chapter covers sorting, an extremely important operation for controlling how MySQL displays results from SELECT statements. To sort a query result, add an ORDER BY clause to the query

You can sort rows of a query result several ways:
- Using a single column, a combination of columns, or even parts of columns or expression results

- Using ascending or descending order

- Using case-sensitive or case-insensitive string comparisons

- Using temporal ordering

Many example in This chapter use table driver_log & mail:

```
mysql> SELECT * FROM driver_log;
+--------+-------+------------+-------+
| rec_id | name  | trav_date  | miles |
+--------+-------+------------+-------+
|      1 | Ben   | 2014-07-30 | 120   |
|      2 | Suzi  | 2014-07-29 | 121   |
|      3 | Henry | 2014-07-29 | 122   |
|      4 | Henry | 2014-07-27 | 123   |
|      5 | Ben   | 2014-07-29 | 124   |
|      6 | Henry | 2014-07-26 | 125   |
|      7 | Suzi  | 2014-08-02 | 126   |
|      8 | Henry | 2014-08-01 | 127   |
+--------+-------+------------+-------+

mysql> SELECT * FROM mail;
+---------------------+---------+---------+---------+---------+---------+
| t                   | srcuser | srchost | dstuser | dsthost | size    |
+---------------------+---------+---------+---------+---------+---------+
| 2014-05-11 10:15:08 | barb    | saturn  | tricia  | mars    | 58274   |
| 2014-05-11 10:15:08 | barb    | saturn  | tricia  | mars    | 58274   |
| 2014-05-11 10:15:08 | barb    | saturn  | tricia  | mars    | 58274   |
| 2014-05-11 10:15:08 | barb    | saturn  | tricia  | mars    | 58274   |
| 2014-05-12 12:48:13 | tricia  | mars    | gene    | venus   | 194925  |
+---------------------+---------+---------+---------+---------+---------+
```

## Using ORDER BY to Sort Query Results

ORDER BY has the following general characteristics:

- You can sort using one or more column or expression values.

- You can sort columns independently in ascending order (the default) or descending order.

- You can refer to sort columns by name or by using an alias.

---
## MySQL doesn’t sort something unless you tell it to

> The overall order of rows returned by a query is indeterminate unless you specify an ORDER BY clause.
---

Some usings:

- `SELECT * FROM driver_log ORDER BY name;` => order name Ascending (The default sort direction is ascending.)

- `SELECT * FROM driver_log ORDER BY name, trav_date;` => order name Ascending, each same name, order trav_date Ascending

```
+--------+-------+------------+
| rec_id | name  | trav_date  |
+--------+-------+------------+
|      5 | Ben   | 2014-07-26 |
|      1 | Ben   | 2014-07-27 |
|      9 | Ben   | 2014-07-28 |
|      6 | Henry | 2014-07-26 |
|      4 | Henry | 2014-07-27 |
|      3 | Henry | 2014-07-28 |
|     10 | Henry | 2014-07-29 |
+--------+-------+------------+
```

- `SELECT * FROM driver_log ORDER BY name DESC, trav_date;` => order name Descending, each same name, order trav_date Ascending

## Using Expressions for Sorting

You want to sort a query result based on values calculated from a column rather than traditional column of table.

Solution: Put the expression that calculates the values in the ORDER BY clause.

```
mysql> SELECT t, srcuser, FLOOR((size+1023)/1024)
-> FROM mail WHERE size > 50000
-> ORDER BY FLOOR((size+1023)/1024);

OR using naming alias:

mysql> SELECT t, srcuser, FLOOR((size+1023)/1024) AS kilobytes
-> FROM mail WHERE size > 50000
-> ORDER BY kilobytes;

+---------------------+---------+-----------+
| t                   | srcuser | kilobytes |
+---------------------+---------+-----------+
| 2014-05-11 10:15:08 | barb    |        57 |
| 2014-05-14 14:42:21 | barb    |        96 |
| 2014-05-12 12:48:13 | tricia  | 191       |
| 2014-05-15 10:25:52 | gene    | 200       |
+---------------------+---------+-----------+
```

You might prefer the alias method

## Displaying One Set of Values While Sorting by Another

- You can sorting with another column that not appear on select statement or query.

```
mysql> SELECT id, email
-> FROM users ORDER BY name;


mysql> SELECT t, srcuser,
-> CONCAT(FLOOR((size+1023)/1024),'K') AS size_in_K
-> FROM mail WHERE size > 50000
-> ORDER BY size;

+---------------------+---------+-----------+
| t                   | srcuser | size_in_K |
+---------------------+---------+-----------+
| 2014-05-11 10:15:08 | barb    | 57K       |
| 2014-05-14 14:42:21 | barb    | 96K       |
| 2014-05-12 12:48:13 | tricia  | 191K      |
| 2014-05-15 10:25:52 | gene    | 976K      |
| 2014-05-14 17:03:01 | tricia  | 2339K     |
+---------------------+---------+-----------+
```

- Displaying values as strings but sorting them as numbers helps solve some otherwise difficult problems.

Example, for a table:

```
CREATE TABLE roster (
  name CHAR(30), #playername
  jersey_num  CHAR(3)     # jersey number
);
```

```
mysql> SELECT name, jersey_num FROM roster ORDER BY jersey_num;

+-----------+------------+
| name      | jersey_num |
+-----------+------------+
| Ella      | 0          |
| Nancy     | 00         |
| Elizabeth | 100        |
| Lynne     | 29         |
| Sherry    | 47         |
| Jean      | 8          |
+-----------+------------+
```

The values 100 and 8 are wrong of place, but that’s easily solved: display the string values and use the numeric values for sorting. To accomplish this, `add zero to the jer sey_num values to force a string-to-number conversion`:

```
mysql> SELECT name, jersey_num FROM roster ORDER BY jersey_num+0;

+-----------+------------+
| name      | jersey_num |
+-----------+------------+
| Ella      | 0          |
| Nancy     | 00         |
| Jean      | 8          |
| Lynne     | 29         |
| Sherry    | 47         |
| Elizabeth | 100        |
+-----------+------------+
```

- Suppose that a names table contains last and first names. To display rows sorted by last name first, the query is straightforward when the columns are displayed separately:

```
mysql> SELECT last_name, first_name FROM name
-> ORDER BY last_name, first_name;
+-----------+------------+
| last_name | first_name |
+-----------+------------+
| Blue      | Vida       |
| Brown     | Kevin      |
| Gray      | Pete       |
| White     | Devon      |
| White     | Rondell    |
+-----------+------------+
```

```
mysql> SELECT CONCAT(first_name,' ',last_name) AS full_name
-> FROM name ORDER BY last_name, first_name

+---------------+
| full_name     |
+---------------+
| Vida Blue     |
| Kevin Brown   |
| Devon White   |
| Rondell White |
+---------------+
```

## Date-Based Sorting

Many database tables include date or time information and it’s very often necessary to sort results in temporal order. MySQL knows how to sort temporal data types, so there’s no special trick to ordering them

- Sorting be date: (most recently using order by desc):

  - `SELECT * FROM mail WHERE srcuser = 'phil' ORDER BY t DESC;`

- Sorting by time of day:

  - `SELECT * FROM mail ORDER BY TIME(t);` # t is datetime (2014-05-15 07:17:48)

- Sorting by calendar day:

  - `SELECT date, description FROM occasion ORDER BY date;`

- To put these items in calendar order, sort them by month and day within month:

  - `SELECT date, description FROM occasion ORDER BY MONTH(date), DAYOFMONTH(date);`

- Display day names using DAYNAME(), but sort in day-of-week order using DAYOFWEEK(), which returns numeric values from 1 to 7 for Sunday through Saturday:

  - `SELECT DAYNAME(date) AS day, date, description FROM occasion ORDER BY DAYOFWEEK(date);`

  ```
  +----------+------------+-------------------------------------+
  | day      | date       | description                         |
  +----------+------------+-------------------------------------+
  | Sunday   | 1944-06-06 | D-Day at Normandy Beaches           |
  | Sunday   | 1944-06-06 | D-Day at Normandy Beaches           |
  | Monday   | 1944-06-06 | D-Day at Normandy Beaches           |
  | Tuesday  | 1944-06-06 | D-Day at Normandy Beaches           |
  | Thursday | 1989-11-09 | Opening of the Berlin Wall          |
  | Friday   | 1957-10-04 | Sputnik launch date                 |
  | Friday   | 1732-02-22 | George Washington's birthday        |
  | Saturday | 1789-07-04 | US Independence Day                 |
  | Saturday | 1919-06-28 | Signing of the Treaty of Versailles |
  +----------+------------+-------------------------------------+
  ```

## Sorting by Fixed-Length Substrings

Pull out the parts you need with LEFT(), MID(), or RIGHT(), and sort them.

```
mysql> SELECT * FROM housewares ORDER BY id;
+------------+------------------+
| id         | description      |
+------------+------------------+
| BED00038SG | bedside lamp     |
| BTH00415JP | lavatory         |
| BTH00485US | shower stall     |
| DIN40672US | dining table     |
| KIT00372UK | garbage disposal |
| KIT01729JP | microwave oven   |
+------------+------------------+
```

```
mysql> SELECT id,
-> LEFT(id,3) AS category,
-> MID(id,4,5) AS serial,
-> RIGHT(id,2) AS country
-> FROM housewares;

+------------+----------+--------+---------+
| id         | category | serial | country |
+------------+----------+--------+---------+
| DIN40672US | DIN| 40672  | US      |
| KIT00372UK | KIT| 00372  | UK      |
| KIT01729JP | KIT| 01729  | JP      |
| BED00038SG | BED| 00038  | SG      |
| BTH00485US | BTH| 00485  | US      |
| BTH00415JP | BTH| 00485  | US      |
+------------+----------+--------+---------+
```

We can enhance with order by:

- `SELECT * FROM housewares ORDER BY LEFT(id,3);`

- `SELECT id, LEFT(id,3) AS category ORDER BY category;`

## Sorting by Variable-Length Substrings

- using `SUBSTRING()`

- using `SUBSTRING_INDEX()` : To extract segments from these values, use SUBSTRING_INDEX(str,c,n). It searches a string str for the n-th occurrence of a given character c and returns everything to the left of that character.

```
mysql> SELECT name,
-> SUBSTRING_INDEX(SUBSTRING_INDEX(name,'.',-3),'.',1) AS leftmost,
-> SUBSTRING_INDEX(SUBSTRING_INDEX(name,'.',-2),'.',1) AS middle,
-> SUBSTRING_INDEX(name,'.',-1) AS rightmost
-> FROM hostname;

+--------------------+----------+----------+-----------+
| name               | leftmost | middle   | rightmost |
+--------------------+----------+----------+-----------+
| svn.php.net        | svn      | php      | net       |
| dbi.perl.org       | dbi      | perl     | org       |
| lists.mysql.com    | lists    | mysql    | com       |
| mysql.com          | mysql    | mysql    | com       |
| jakarta.apache.org | jakarta  | apache   | org       |
| www.kitebird.com   | www      | kitebird | com       |
+--------------------+----------+----------+-----------+
```

- using INET_ATON to sort ip address:

```
SELECT ip FROM hostip ORDER BY INET_ATON(ip);

+-----------------+
| ip              |
+-----------------+
| 21.0.0.1        |
| 127.0.0.1       |
| 192.168.0.2     |
| 192.168.0.10    |
| 192.168.1.2     |
| 192.168.1.10    |
| 255.255.255.255 |
+-----------------+
```

## Floating Values to the Head or Tail of the Sort Order

- To sort a result set normally except that you want particular values first, create an ad‐ ditional sort column that is 0 for those values and 1 for everything else. This enables you to float the values to the head of the sort order. To put the values at the tail instead, use the additional column to map the values to 1 and all other values to 0

```
mysql> SELECT val FROM t ORDER BY val;;
+------+
| val  |
+------+
| NULL |
| NULL |
| 3    |
| 9    |
| 100  |
+------+

mysql> SELECT val FROM t ORDER BY IF(val IS NULL,1,0), val;
+------+
| val  |
+------+
| 3    |
| 9    |
| 100  |
| NULL |
| NULL |
+------+
```

- The IF() expression creates a new column for the sort that is used as the primary sort value.

## Defining a Custom Sort Order

You want to sort values in a nonstandard order.

Use FIELD() to map column values to a sequence that places the values in the desired order.

The following FIELD() call compares value to str1, str2, str3, and str4, and returns 1, 2, 3, or 4, depending on which of them value is equal to:

`FIELD(value,str1,str2,str3,str4)`

If value is NULL or none of the values match, FIELD() returns 0.

```
mysql> SELECT rec_id, name FROM driver_log
-> ORDER BY FIELD(name,'Henry','Suzi','Ben');

+--------+-------+
| rec_id | name  |
+--------+-------+
|     10 | Henry |
|      8 | Henry |
|      6 | Henry |
|      7 | Suzi  |
|      2 | Suzi  |
|      5 | Ben   |
|      9 | Ben   |
+--------+-------+
```

## Sorting ENUM Values

ENUM values don’t sort like other string columns.

Suppose create one table using ENUM:

```
CREATE TABLE weekday (
  day ENUM('Sunday','Monday','Tuesday','Wednesday', 'Thursday','Friday','Saturday')
);

mysql> INSERT INTO weekday (day) VALUES('Monday'),('Friday'),
-> ('Tuesday'), ('Sunday'), ('Thursday'), ('Saturday'), ('Wednesday');


mysql> SELECT day, day+0 FROM weekday;

+-----------+-------+
| day       | day+0 |
+-----------+-------+
| Monday    | 2     |
| Friday    | 6     |
| Tuesday   | 3     |
| Sunday    | 1     |
| Thursday  | 5     |
| Saturday  | 7     |
| Wednesday | 4     |
+-----------+-------+

mysql> SELECT day, day+0 FROM weekday ORDER BY day;

+-----------+-------+
| day       | day+0 |
+-----------+-------+
| Sunday    | 1     |
| Monday    | 2     |
| Tuesday   | 3     |
| Wednesday | 4     |
| Thursday  | 5     |
| Friday    | 6     |
| Saturday  | 7     |
+-----------+-------+
```

What about occasions when you want to sort ENUM values in lexical order (alpha-beta)? Force them to be treated as strings for sorting using the CAST() function:

```
mysql> SELECT day, day+0 FROM weekday ORDER BY CAST(day AS CHAR);

+-----------+-------+
| day       | day+0 |
+-----------+-------+
| Friday    | 6     |
| Monday    | 2     |
| Saturday  | 7     |
| Sunday    | 1     |
| Thursday  | 5     |
| Tuesday   | 3     |
| Wednesday | 4     |
+-----------+-------+
```