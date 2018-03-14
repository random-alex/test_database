# test_database
### DR;TL Create PostgreSQL database , connect to it to R and play with it.
First of all we should create a data base in postgreSQL. To do it, run this chunk :
```
create table dbo.customer	(
    customer_id	serial PRIMARY KEY,
   	customer_name	varchar(256)	NOT NULL
)

create table dbo.purchase_order	(
			purchase_order_id	serial	PRIMARY KEY
		,	customer_id		int	NOT NULL
		,	amount			money	NOT NULL
		,	order_date		date	NOT NULL
)
```

Then let's connect to this database in R. To do so we only need to install DBI packadge, upload it and then run this chunk:
```
con <- DBI::dbConnect(odbc::odbc(),
                      driver = "PostgreSQL UNICODE",
                      database = "alex",
                      UID    = rstudioapi::askForPassword("Database user"),
                      PWD    = rstudioapi::askForPassword("Database password"),
                      host = "localhost",
                      port = 5432)
```
Horay! We connect)


