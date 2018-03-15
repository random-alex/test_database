
# prereq ------------------------------------------------------------------
require(tidyverse)
require(dbplyr)
require(DBI)
require(stringr)
require(randomNames)


# functions ----------------------------------------------------------------

meanCI <- function(x, a = .05, t = TRUE){
  q <- ifelse(t, qt(1 - a/2, df = length(x) - 1),
              qnorm(1 - a/2))
  return(mean(x) + q*sem(x)*c(-1, 1))
}

sem <- function(x) sd(x)/sqrt(length(x))

# create connection -------------------------------------------------------

con <- DBI::dbConnect(odbc::odbc(),
                      driver = "PostgreSQL UNICODE",
                      database = "alex",
                      UID    = 'alex',  #rstudioapi::askForPassword("Database user"),
                      PWD    = rstudioapi::askForPassword("Database password"),
                      host = "localhost",
                      port = 5432)
#get tables names
tab <- dbListTables(con)

#get column names of specified column
dbListFields(con,tab[2])
#delete all previous data from tables(because this is toy example)
dbGetQuery(con, str_c("DELETE FROM ",tab[1]))
dbGetQuery(con, str_c("DELETE FROM ",tab[2]))


# creatr and upload data to database --------------------------------------

size = 500
size_cus = 100
df_cus <- data.frame(customer_id = c(1:size),
                     customer_name = randomNames(size))

df_pur <- data.frame(purschase_order_id = c(1:(size * size_cus)),
                     customer_id = rep(c(1:size),each = size_cus ),
                     amount = round(abs(rnorm(size * size_cus,mean = 5000,sd = 200)),digits = 2),
                     order_date = sample(seq(as.Date('2000/01/01'), Sys.Date(), by="day"), size * size_cus,replace = TRUE)
                     )

#write data to database
dbWriteTable(con,name = tab[1],df_cus,append = T)
dbWriteTable(con,name = tab[2],df_pur,append = T)

# play with created data via data base ------------------------------------


db_cus <- tbl(con, tab[1])
db_pur <- tbl(con, tab[2])

db_pur %>% 
  group_by(customer_id) %>% 
  filter(!(as.numeric(amount) %in% meanCI(as.numeric(amount))))

dbGetQuery(con, 
"SELECT customer_name, order_date, amount
FROM dbo_customer as dc
LEFT JOIN (SELECT customer_id as c_id2, order_date,amount 
          FROM dbo_purchase_order 
          INNER JOIN (SELECT customer_id as nest_id, 0.95*max(amount::numeric) as amount_max, 1.05*min(amount::numeric) as amount_min
                      FROM dbo_purchase_order 
                      GROUP BY customer_id) as nest
          ON customer_id = nest_id 
          WHERE amount::numeric > amount_max OR amount::numeric < amount_min
          ORDER BY customer_id) as dm
ON dc.customer_id = dm.c_id2
ORDER BY customer_name,order_date") %>% as.tibble()







