# using cat to output sth, thus you know your function is working
# 2013 Aug 31
# chengjun wang@amoy house


## one case
x = c(1:100)
y = c(200:300)

cat_fun = function(x){
	for (i in c(1:length(x))){
		Sys.sleep(0.5)
    for (j in c(1:length(y))){
      cat("R is running for", "topic", x[i], "fold", y[i], 
          as.character(as.POSIXlt(Sys.time(), "Asia/Shanghai")), "\n")     
    }
			}
}

cat_fun(x)

system.time(cat_fun(x))

## system timezone

Sys.timezone()

tzfile <- file.path(R.home("share"), "zoneinfo", "zone.tab")
tzones <- read.delim(tzfile, row.names = NULL, header = FALSE,
                     col.names = c("country", "coords", "name", "comments"),
                     as.is = TRUE, fill = TRUE, comment.char = "#")
str(tzones$name)