# test_database
### TL;DR: 1.Create PostgreSQL database , connect to it to R and implement SQL query
###        2.Calculate sample size
Database, that I use. Made in PostgreSQL
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
SQL query to this data base 
```
SELECT customer_name, order_date, amount
FROM dbo_customer as dc
LEFT JOIN (SELECT c_id2, order_date, amount
 FROM (SELECT customer_id as c_id2, order_date,amount ,
    rank() OVER( 
       PARTITION BY customer_id
       ORDER BY amount
     ),
    ROW_NUMBER() OVER( 
       PARTITION BY customer_id
       ORDER BY amount DESC
     ) as rank_max
          FROM dbo_purchase_order 
          INNER JOIN (SELECT customer_id as nest_id, 0.95*max(amount::numeric) as amount_max
                      FROM dbo_purchase_order 
                      GROUP BY customer_id) as nest
          ON customer_id = nest_id 
          WHERE amount::numeric > amount_max 
          ORDER BY customer_id ) as dbo_purchase_order_short
WHERE rank < 3 OR rank_max < 3) as dm
ON dc.customer_id = dm.c_id2
ORDER BY customer_name,amount
```
____________________________________________________________________________________________________________________

I use second formula for sample size calculation from this http://statistica.ru/local-portals/medicine/planirovanie-meditsinskikh-issledovaniy/
For parameters p0= 0.6, pk = 0.7 minimal sample size is 3 
