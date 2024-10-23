---
layout: post
title: Setup readonly access for PostgreSQL
subtitle:
cover-img: /assets/img/path.jpg
thumbnail-img: /assets/img/postgresql.png
share-img: /assets/img/path.jpg
tags: [postgresql]
author: kieetnvt
---

Guide to create a linux user and grant read-only access for it for database.

1) Create a linux user and set password

```
sudo adduser read_access
```

Then enter your password for this user

2) Limit permission for the user (option)

Normally, this user only has root permission on it's directory. (/home/read_access)

3) Set read-only role for this user to use Postgresql

```
psql -U postgres -d <your database>
```

After connected to `psql` console

```
CREATE USER read_access WITH PASSWORD '<your password>';

GRANT CONNECT ON DATABASE <your database> TO read_access;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_access;

GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO read_access;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO read_access;

ALTER USER read_access SET default_transaction_read_only = on;
```

4) Dump your database

```
PGPASSWORD="<your password>" pg_dump -Fc --no-acl --no-owner -h localhost -U read_access -d <your database> -t <your table> > mydb.dump
```

5) If you try to "change you will get this error"

```
ERROR:  cannot execute INSERT in a read-only transaction
```


