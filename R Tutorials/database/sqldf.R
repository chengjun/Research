# SQL select on data frames

require(sqldf)
require(RSQLite)


##########
"RSQLite"
##########

# create a SQLite instance and create one connection.
m <- dbDriver("SQLite")

# initialize a new database to a tempfile and copy some data.frame
# from the base package into it
tfile <- tempfile()
con <- dbConnect(m, dbname = tfile)
data(USArrests)
dbWriteTable(con, "USArrests", USArrests)

# query
rs <- dbSendQuery(con, "select * from USArrests")
d1 <- fetch(rs, n = 10)      # extract data in chunks of 10 rows
dbHasCompleted(rs)
d2 <- fetch(rs, n = -1)      # extract all remaining data
dbHasCompleted(rs)
dbClearResult(rs)
dbListTables(con)

# clean up
dbDisconnect(con)
file.info(tfile)
file.remove(tfile)

##########
"sqldf"
##########
data(CO2)


"http://www.burns-stat.com/translating-r-sql-basics/?utm_source=rss&utm_medium=rss&utm_campaign=translating-r-sql-basics"

myCO2 <- CO2
attributes(myCO2) <- attributes(CO2)[c("names", "row.names", "class")]
class(myCO2) <- "data.frame"
s01 <- sqldf("select Type, conc from myCO2") # Two columns of Type and conc

r01 <- myCO2[, c("Type", "conc")]

all.equal(s01, r01)

someCols <- c("Type", "conc")
r01b <- myCO2[, someCols]
