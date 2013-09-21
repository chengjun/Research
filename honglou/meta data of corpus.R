D.3.12. tm-corpus-make.R
# setwd ("/ media / NTFS500GB _A/pnas - scrapy / pnas /")

meta _df <- read . table (" meta .csv", header = T, sep=",",
                            4 quote ="\"", encoding = "UTF -8", stringsAsFactors = F)

require ("tm")

abstracts _ reader <- FunctionGenerator ( function (...)
  function (elem , language , id) {
    PlainTextDocument (x = elem $ content ,
                          datetimestamp = as. POSIXlt (Sys. time () , tz = "GMT"),
                          # heading = elem $ content [[1]] ,
                          id = id ,
                          origin = elem $uri ,
                          language = language )
    })

abstracts _ source <- DirSource (".",pattern = "\\. abstract \\. txt", recursive = TRUE )

abstracts <- Corpus ( abstracts _source , readerControl = list (
  reader = abstracts _reader , language = "en_US"))

## reformat paths
meta _df$ abstract _ local _ path <- paste ("./",
                                              meta _df$ abstract _ local _path , sep="")

## we have complete and unique metadata , now find abstracts in corpus
abstracts _ origin _chr <- sapply ( abstracts , Origin )
 corpus _ reordered _ index <- match ( meta _df$ abstract _ local _path ,
                                         abstracts _ origin _chr)
 ## select abstracts by available metadata
 abstracts <- abstracts [ corpus _ reordered _ index ]

## select metadata to match the corpus
abstracts _ origin _chr <- sapply ( abstracts , Origin )
meta _ reordered _ index <- match ( abstracts _ origin _chr ,
                                      meta _df$ abstract _ local _ path )
meta _df <- meta _df[ meta _ reordered _index ,]

# now metadata can be merged into corpus
# names ( meta _df)
for ( name in names ( meta _df)[-c (10 ,13 ,14 ,15 ,25) ])
  meta ( abstracts , tag = name ) <- meta _df[ name ]

# does not work :
# sapply ( names ( meta _df), function (x) meta ( abstracts , tag=x) <- meta _df[x])

## also :
# DMetaData ( abstracts )$ title <- meta _df$ title
# meta ( abstracts )$ title [1]

save ( abstracts , file = "tm -corpus -pnas - abstracts .rda", compress = TRUE )
                                    