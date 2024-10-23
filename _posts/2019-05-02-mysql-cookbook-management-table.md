---
layout: post
title: MySQL Cookbook Chapter
subtitle: Table Management
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/mysql.png
share-img: /assets/img/path.jpg
tags: [ruby]
author: kieetnvt
---

# Basic How to Management Tables: Cloning, Copying, Temporary table, Unique Table Name & Determining what storage engine a table

## Cloning a Table: You want to create a table that has exactly the same structure as an existing table?

  - Use CREATE TABLE ... LIKE to clone the table structure. To also copy some or all of the rows from the original table to the new one, use INSERT INTO ... SELECT.

  - `CREATE TABLE new_table LIKE original_table;`:

    - The structure of the new table is the same as that of the original table

    - Doesn’t copy foreign key definitions

    - Doesn’t copy any DATA DIRECTORY or INDEX DIRECTORY

    - The new table is empty

  - If you also want the contents to be the same as the original table:

    `INSERT INTO new_table SELECT * FROM original_table;`

## Saving a Query Result in a Table:

  - Problem: You want to save the result from a SELECT statement to a table rather than display it.

  - If the table exists, retrieve rows into it using INSERT INTO ... SELECT. If the table does not exist, create it on the fly using CREATE TABLE ... SELECT.

  - Why we need it?

    - You can easily create a complete or partial copy of a table. If you’re developing an algorithm that modifies a table, it’s safer to work with a copy of a table so that you need not worry about the consequences of mistakes. If the original table is large, creating a partial copy can speed the development process because queries run against it take less time.

    - For a data-loading operation based on information that might be malformed, load new rows into a temporary table, perform some preliminary checks, and correct the rows as necessary. When you’re satisfied that the new rows are okay, copy them from the temporary table to your main table.

    - Some applications maintain a large repository table and a smaller working table into which rows are inserted on a regular basis, copying the working table rows to the repository periodically and clearing the working table.

    - To perform summary operations on a large table more efficiently, avoid running expensive summary operations repeatedly on it. Instead, select summary informa‐ tion once into a second table and use that for further analysis.

  - If the destination table already exists, use `INSERT ... SELECT` to copy the result set into it:

    - For example, if dst_tbl contains an integer column i and a string column s, the following statement copies rows from src_tbl into dst_tbl, assigning column val to i and column name to s:

      - `INSERT INTO dst_tbl (i, s) SELECT val, name FROM src_tbl;`

      - The number of columns to be inserted must match the number of selected columns

      - To copy all columns:

        - `INSERT INTO dst_tbl SELECT * FROM src_tbl;`

      - To insert with certain rows, using WHERE:

        - `INSERT INTO dst_tbl SELECT * FROM src_tbl WHERE val > 100 AND name LIKE 'A%';`

      - The SELECT statement can produce values from expressions, too. For example, the fol‐ lowing statement counts the number of times each name occurs in src_tbl and stores both the counts and the names in dst_tbl:

        - `INSERT INTO dst_tbl (i, s) SELECT COUNT(*), name FROM src_tbl GROUP BY name;`

  - If the destination table does not exist, create it first with a CREATE TABLE statement, then copy rows into it with INSERT ... SELECT:

    - Alternatively, use CREATE TABLE ... SELECT to create the destination table directly from the result of the SELECT:

      - `CREATE TABLE dst_tbl SELECT * FROM src_tbl;`

    - MySQL creates the columns in dst_tbl based on the name, number, and type of the columns in src_tbl.

    - To copy only certain rows, add an appropriate WHERE clause. To create an empty table, use a WHERE clause that selects no rows:

      - `CREATE TABLE dst_tbl SELECT * FROM src_tbl WHERE FALSE;`

    - To copy only some of the columns, name the ones you want in the SELECT part of the statement. For example, if src_tbl contains columns a, b, c, and d, copy just b and d like this:

      - `CREATE TABLE dst_tbl SELECT b, d FROM src_tbl;`

    - To create columns in an order different from that in which they appear in the source table, name them in the desired order:

      - `CREATE TABLE dst_tbl SELECT c, a, b FROM src_tbl;`

    - The following statement creates id as an AUTO_INCREMENT column in dst_tbl and adds columns a, b, and c from src_tbl:

      - ```
        CREATE TABLE dst_tbl (
        id INT NOT NULL AUTO_INCREMENT,
        PRIMARY KEY (id) )
        SELECT a, b, c FROM src_tbl;
        ```

    -  Suppose that src_tbl contains invoice information that lists items in each invoice. The following statement generates a summary that lists each invoice named in the table and the total cost of its items, using an alias for the expression:

      - ```
        CREATE TABLE dst_tbl
        SELECT inv_no, SUM(unit_cost*quantity) AS total_cost
        FROM src_tbl GROUP BY inv_no;
        ```

  - CREATE TABLE ... SELECT is extremely convenient, but has some limitations that arise from the fact that the information available from a result set is not as extensive as what you can specify in a CREATE TABLE statement

  - MySQL has no idea whether a result set column should be indexed or what its default value is:

    - To make the destination table an exact copy of the source table, use the cloning technique

    - To include indexes in the destination table, specify them explicitly.:

      - For example, if src_tbl has a PRIMARY KEY on the id column, and a multiple-column index on state and city, specify them for dst_tbl as well:

        - ```
          CREATE TABLE dst_tbl (PRIMARY KEY (id), INDEX(state,city))
          SELECT * FROM src_tbl;
          ```

    - Column attributes such as AUTO_INCREMENT and a column’s default value are not copied to the destination table.

    - To preserve these attributes, create the table, then use ALTER TABLE to apply the appropriate modifications to the column definition:

      - ```
        CREATE TABLE dst_tbl (PRIMARY KEY (id)) SELECT * FROM src_tbl;
          ALTER TABLE dst_tbl
          MODIFY id INT UNSIGNED NOT NULL AUTO_INCREMENT;
        ```

---

## Creating Temporary Tables:

### You need a table only for a short time, after which you want it to disappear automatically

#### Solution: Create a table using the TEMPORARY keyword, and let MySQL take care of removing it

- Some operations require a table that exists only temporarily and that should disappear when it’s no longer needed. You can, of course, execute a DROP TABLE statement explicitly to remove a table when you’re done with it

- Another option is to use CREATE TEMPORA RY TABLE. This statement is like CREATE TABLE but creates a transient table that disappears when your session with the server ends, if you haven’t already removed it yourself:

  - Create the table from explicit column definitions:

    - `CREATE TEMPORARY TABLE tbl_name (...column definitions...);`

  - Create the table from an existing table:

    - `CREATE TEMPORARY TABLE new_table LIKE original_table;`

  - Create the table on the fly from a result set:

    - `CREATE TEMPORARY TABLE tbl_name SELECT ... ;`

> Temporary tables are session-specific, so multiple clients can each create a temporary table having the same name without interfering with each other. This makes it easier to write applications that use transient tables because you need not ensure that the tables have unique names for each client

> A temporary table can have the same name as a permanent table. In this case, the tem‐ porary table “hides” the permanent table for the duration of its existence, which can be useful for making a copy of a table that you can modify without affecting the original by mistake. The DELETE statement in the following example removes rows from a tem‐ porary mail table, leaving the original permanent table unaffected

```
mysql> CREATE TEMPORARY TABLE mail SELECT * FROM mail; mysql> SELECT COUNT(*) FROM mail;
+----------+
| COUNT(*) |
+----------+
| 16 |
+----------+
mysql> DELETE FROM mail;
mysql> SELECT COUNT(*) FROM mail;
+----------+
| COUNT(*) |
+----------+
| 0|
+----------+
mysql> DROP TEMPORARY TABLE mail; mysql> SELECT COUNT(*) FROM mail;
+----------+
| COUNT(*) |
+----------+
|       16 |
+----------+
```

#### Although temporary tables created withCREATETEMPORARYTABLEhave the benefits just discussed, keep the following caveats in mind:

- To reuse a temporary table within a given session, you must still drop it explicitly before re-creating it. Attempting to create a second temporary table with the same name results in an error.

- If you modify a temporary table that “hides” a permanent table with the same name, be sure to test for errors resulting from dropped connections if you use a program‐ ming interface that has reconnect capability enabled. If a client program automat‐ ically reconnects after detecting a dropped connection, modifications affect the permanent table after the reconnect, not the temporary table.

- Some APIs support persistent connections or connection pools. These prevent temporary tables from being dropped as you expect when your script ends because the connection remains open for reuse by other scripts. Your script has no control over when the connection closes. This means it can be prudent to execute the fol‐ lowing statement prior to creating a temporary table, just in case it’s still in existence from a previous execution of the script:

```
DROP TEMPORARY TABLE IF EXISTS tbl_name

```

The TEMPORARY keyword is useful here if the temporary table has already been dropped, to avoid dropping any permanent table that has the same name.

## Generating Unique Table Names:

> You need to create a table with a name guaranteed not to exist.

Using Process ID (PID) to make table has unique table name

>  Pro‐ cess ID (PID) values are a better source of unique values. PIDs are reused over time, but never for two processes at the same time, so a given PID is guaranteed to be unique among the set of currently executing processes

```
Ruby:

tbl_name = "tmp_tbl_" + Process.pid.to_s
```

Connection identifiers are another source of unique values. The MySQL server reuses these numbers over time, but no two simultaneous connections to the server have the same ID. To get your connection ID, execute this statement and retrieve the result:

`SELECT CONNECTION_ID();`


## Checking or Changing a Table Storage Engine:

To determine a table’s storage engine, you can use any of several statements. To change the table’s engine, use ALTER TABLE with an ENGINE clause.

> MySQL supports multiple storage engines, which have differing characteristics. For example, the InnoDB engine supports transactions, whereas MyISAM does not. If you need to know whether a table supports transactions, check which storage engine it uses. If the table’s engine does not support transactions, you can convert the table to use a transaction-capable engine.
To determine the current engine for a table, check INFORMATION_SCHEMA or use the SHOW TABLE STATUS or SHOW CREATE TABLE statement

```
SHOW TABLE STATUS LIKE 'mail'\G

ALTER TABLE mail ENGINE = MyISAM;
```

## Copying a Table Using mysqldump

- You want to copy a table or tables, either among the databases managed by a MySQL server, or from one server to another.

- The mysqldump program makes a backup:

  - `mysqldump cookbook mail > mail.sql`

- The output file mail.sql consists of a CREATE TABLE statement to create the mail table and a set of INSERT statements to insert its rows. You can reload the file to re-create the table should the original be lost:

  - `mysql cookbook < mail.sql`

### Copying tables within a single MySQL server

- Copy a single table to a different database:

```
% mysqldump cookbook mail > mail.sql  (To dump multiple tables, name them all following the database name)

% mysql other_db < mail.sql
```

- Copy all tables in a database to a different database:

```
% mysqldump cookbook > cookbook.sql

% mysql other_db < cookbook.sql
```

- Copy a table, using a different name for the copy:

  - Dump the table:

    - `% mysqldump cookbook mail > mail.sql`

  - Reload the table into a different database that does not contain a table with that name:

    - `% mysql other_db < mail.sql`

  - Rename the table:

    - `% mysql other_db`

    - `mysql> RENAME mail TO mail2;`

  - Or, to move the table into another database at the same time, qualify the new name with the database name:

    - `% mysql other_db`

    - `mysql> RENAME mail TO cookbook.mail2;`

### To perform a table-copying operation without an intermediary file, use a pipe:

```
mysqldump cookbook mail | mysql other_db

mysqldump cookbook | mysql other_db

```

### Copying tables between MySQL servers

#### Normal way:

1. SSH to host_A and create file dump at host_A, use mysqldump

2. Upload to host_B, use scp

3. Load the table into that MySQL server’s other_db, use mysql other_db < mail.sql

#### Using PIPE way:

- If you can connect to both servers from your local host:

`% mysqldump cookbook mail | mysql -h other-host.example.com other_db`

- If you cannot connect directly to the remote server using mysql from your local host, send the dump output into a pipe that uses ssh to invoke mysql remotely on other- host.example.com:

`% mysqldump cookbook mail | ssh other-host.example.com mysql other_db`

> SSH connects to other-host.example.com and launches mysql there. It then reads the mysqldump output from the pipe and passes it to the remote mysql process. ssh can be useful to send a dump over the network to a machine that has the MySQL port blocked by a firewall but that permits connections on the SSH port.

> To copy multiple tables over the network, name them all following the database argument of the mysqldump command. To copy an entire database, don’t specify any table names after the database name; mysqldump dumps all its table.


### Tobe continue with Next Chapter is Generating Summaries
