require(DBI)

devtools::install_github("rstats-db/odbc")
con <- DBI::dbConnect(odbc::odbc(),
                      driver = "PostgreSQL UNICODE",
                      database = "alex",
                      UID    = 'alex',  #rstudioapi::askForPassword("Database user"),
                      PWD    = 'qwerty1994',  #rstudioapi::askForPassword("Database password"),
                      host = "localhost",
                      port = 5432)


dbListTables(con)
