library(gsubfn)

'1. Extract retweeter'
i <- "a @b, c @d"
strapply(i, paste("\\w*", "@", "\\w*", sep = ""), c, simplify = unlist)
regmatches(x, m)

'2. extract html tags'

x = c("<a href=\"http://ashoka.org/taxonomy/term/7\" rel=\"tag\">Environment</a>",          
  "<a href=\"http://ashoka.org/taxonomy/term/6\" rel=\"tag\">Health</a>",              
  "<a href=\"http://ashoka.org/taxonomy/term/32\" rel=\"tag\">Civic Engagement</a>",  
  "<a href=\"http://ashoka.org/taxonomy/term/34\" ?rel=\"tag\">Learning/Education</a>",  
  "None",                                                                     
  "<a href=\"http://ashoka.org/taxonomy/term/34\" rel=\"tag\">Learning/Education</a>" , 
  "<a href=\"http://ashoka.org/taxonomy/term/32\" rel=\"tag\">Civic Engagement</a>"  ,  
  "<a href=\"http://ashoka.org/taxonomy/term/10\" rel=\"tag\">Economic Development</a>",
  "<a href=\"http://ashoka.org/taxonomy/term/7\" rel=\"tag\">Environment</a>"  ,        
  "None"       ,                                                                        
  "<a href=\"http://ashoka.org/taxonomy/term/10\" rel=\"tag\">Economic Development</a>")

strapply(x, ">(.*?)<", c, simplify = TRUE)
