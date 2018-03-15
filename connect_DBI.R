require(DBI)
require(stringr)
require(randomNames)
#create connection
con <- DBI::dbConnect(odbc::odbc(),
                      driver = "PostgreSQL UNICODE",
                      database = "alex",
                      UID    = 'alex',  #rstudioapi::askForPassword("Database user"),
                      PWD    = 'qwerty1994',  #rstudioapi::askForPassword("Database password"),
                      host = "localhost",
                      port = 5432)
#get tables names
tab <- dbListTables(con)

#get column names of specified column
dbListFields(con,tab[2])

#delete all previous data from tables(because this is toy example)
dbGetQuery(con, str_c("DELETE FROM ",tab[1]))
dbGetQuery(con, str_c("DELETE FROM ",tab[2]))
size = 500
size_cus = 100
df_cus <- data.frame(customer_id = c(1:size),
                 customer_name = randomNames(size))

df_pur <- data.frame(purschase_order_id = c(1:(size * size_cus)),
                     customer_id = rep(c(1:size),each = size_cus ),
                     amount = round(abs(rnorm(size * size_cus,mean = 5000,sd = 200)),digits = 2),
                     order_date = sample(seq(as.Date('2000/01/01'), Sys.Date(), by="day"), size * size_cus)
                     )


dbWriteTable(con,name = tab[1],df,append = T)
