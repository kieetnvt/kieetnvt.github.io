---
layout: post
title: MySQL Cookbook Chapter
subtitle: Selecting data from tables basic
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/mysql.png
share-img: /assets/img/path.jpg
tags: [ruby]
author: kieetnvt
---

## Basic How to Selecting Data From Tables


First create table:

```
CREATE TABLE mail
(
  t DATETIME, # when message was sent
  srcuser VARCHAR(8), # sender (source user and host)
  srchost VARCHAR(20),
  dstuser VARCHAR(8), # recipient (destination user and host)
  dsthost VARCHAR(20),
  size BIGINT, # message size in bytes
  INDEX (t)
);

```

- Specific select colums: `SELECT t, srcuser, dstuser, size FROM mail;`

- Using LIKE query with %: `SELECT srcuser FROM mail WHERE srchost LIKE “sub%”;`

- Using SQLFunction on Select: `SELECT t, CONCAT(srcuser, ‘@‘, srchost), size FROM mail;`

```
+---------------------+-----------------------------+---------+
| t                   | CONCAT(srcuser,'@',srchost) | size    |
+---------------------+-----------------------------+---------+
| 2014-05-11 10:15:08 | barb@saturn                 | 58274   |
| 2014-05-12 12:48:13 | tricia@mars                 | 58273   |
| 2014-05-12 15:02:49 | phil@mars                   | 58272   |
| 2014-05-12 18:59:18 | barb@saturn                 | 58271   |
+---------------------+-----------------------------+---------+
```

- Naming Query Result Using `as`:

```
mysql> SELECT
-> DATE_FORMAT(t,'%M %e, %Y') AS ‘Date of message’,
-> CONCAT(srcuser,'@',srchost) AS ‘Message Sender’,
-> size FROM mail;

+---------------------+-----------------------------+---------+
| Date of message     | Message Sender              | size    |
+---------------------+-----------------------------+---------+
| 2014-05-11 10:15:08 | barb@saturn                 | 58274   |
| 2014-05-12 12:48:13 | tricia@mars                 | 58273   |
| 2014-05-12 15:02:49 | phil@mars                   | 58272   |
| 2014-05-12 18:59:18 | barb@saturn                 | 58271   |
+---------------------+-----------------------------+---------+
```

You cannot refer to column aliases in a WHERE clause. Thus, the following statement is illegal

```
mysql> SELECT t, srcuser, dstuser, size/1024 AS kilobytes
-> FROM mail WHERE kilobytes > 500;

ERROR 1054 (42S22): Unknown column 'kilobytes' in 'where clause'
```

To make the statement legal, replace the alias in the WHERE clause with the same column or expression that the alias represents :


```
mysql> SELECT t, srcuser, dstuser, size/1024 AS kilobytes
-> FROM mail WHERE size/1024 > 500;
```

- Default sorting is ASC,, example multiple order by:

This statement names multiple columns in the ORDER BY clause to sort rows by host and by user within each host

```
mysql> SELECT * FROM mail WHERE dstuser = 'tricia'
-> ORDER BY srchost, srcuser;
```

- Working with NULL values, Using IF expression of MySQL:

  - using `IS NULL` & `IS NOT NULL` in query: `SELECT * FROM expt WHERE score IS NULL;`

  - using `IF`:

  ```
  mysql> SELECT subject, test, IF(score IS NULL,'Unknown', score) AS 'score' -> FROM expt;
  +---------+------+---------+
  | subject | test | score   |
  +---------+------+---------+
  | Jane    | A    | 47      |
  | Jane    | B    | Unknown |
  | Jane    | C    | 50      |
  | Jane    | D    | Unknown |
  | Marvin  | A    | 50      |
  | Marvin  | B    | 50      |
  | Marvin  | C    | Unknown |
  | Marvin  | D    | 50      |
  +---------+------+---------+
  ```

- Using Views to Simplify Table Access:

  - Problem: You want to refer to values calculated from expressions without writing the expressions each time you retrieve them.

  - Solution: Use a view defined such that its columns perform the desired calculations.

  ```
  mysql> CREATE VIEW mail_view AS
  -> SELECT
  -> DATE_FORMAT(t,'%M %e, %Y') AS date_sent,
  -> CONCAT(srcuser,'@',srchost) AS sender,
  -> CONCAT(dstuser,'@',dsthost) AS recipient,
  -> size FROM mail;
  ```

  This statement created View, and then we can use View as Table

  ```
  mysql> SELECT date_sent, sender, size FROM mail_view
  -> WHERE size > 100000 ORDER BY size;

    +--------------+---------------+---------+
    | date_sent    | sender        | size    |
    +--------------+---------------+---------+
    | May 12, 2014 | tricia@mars   |  194925 |
    | May 15, 2014 | gene@mars     |  998532 |
    | May 14, 2014 | tricia@saturn | 2394482 |
    +--------------+---------------+---------+
  ```

  I will be have new post about encapsulate calculations with Stored routine, triggers, and Scheduled Event of MySQL

- Selecting Data from Multiple Tables: Using JOINS or SubQUERY:

  - Two types of statements that accomplish this are joins and subqueries. A join matches rows in one table with rows in another and enables you to retrieve output rows that contain columns from either or both tables. A subquery is one query nested within another, to perform a comparison between values selected by the inner query against values selected by the outer query.

  ```
  mysql> SELECT id, name, service, contact_name
      -> FROM profile INNER JOIN profile_contact ON id = profile_id;
  ```

  - id , name of profiles table; service and contact_name of profile_contacts table.

  ```
  mysql> SELECT * FROM profile_contact
    -> WHERE profile_id = (SELECT id FROM profile WHERE name = 'Nancy');

    +------------+----------+--------------+
    | profile_id | service  | contact_name |
    +------------+----------+--------------+
    |          2 | Twitter  | user2-fbrid  |
    |          2 | Facebook | user2-msnid  |
    |          2 | LinkedIn | user2-lnkdid |
    +------------+----------+--------------+
  ```

  Here the subquery appears as a nested SELECT statement enclosed within parentheses

- Selecting Rows from the Beginning, End, or Middle of Query Results:

  - Using LIMIT

  ```
  mysql> SELECT * FROM profile LIMIT 3;

  +----+-------+------------+-------+-----------------------+------+
  | id | name  | birth      | color | foods                 | cats |
  +----+-------+------------+-------+-----------------------+------+
  |  1 | Sybil | 1970-04-13 | black | lutefisk,fadge,pizza  |   0  |
  |  2 | Nancy | 1969-09-30 | white | burrito,curry,eggroll |   3  |
  |  3 | Ralph | 1973-11-02 | red   | eggroll,pizza         |   4  |
  +----+-------+------------+-------+-----------------------+------+
  ```

  LIMIT n means “return at most n rows.” If you specify LIMIT 10, and the result set has only four rows, the server returns four rows.

  - Get middle using LIMIT with 2 arguments: Skip 2 rows and return 1 next row.

  ```
  SELECT * FROM profile ORDER BY birth LIMIT 2,1;

  +----+-------+------------+-------+-----------------------+------+
  |  3 | Ralph | 1973-11-02 | red   | eggroll,pizza         |   4  |
  +----+-------+------------+-------+-----------------------+------+
  ```

### Tobe continue with Next Chapter is Table Management
