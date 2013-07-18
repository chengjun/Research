rm(list=ls(all=T));

outfile.gexf <- "dh2010.gexf";
decaytime = 3600;
buffer = 0;
eid = 1;

tweets <- read.csv(file.choose(), head=T, sep="|", quote="", fileEncoding="UTF-8");
ats <- tweets[grep("@([a-z0-9_]{1,15}):?", tweets$text),];
g.from <- tolower(as.character(ats$from_user))
g.to <- tolower(gsub("^.*@([a-z0-9_]{1,15}):?.*$", "\\1", ats$text, perl=T));
g.start <- ats$time - min(ats$time) + buffer;
g.end <- ats$time - min(ats$time) + decaytime + buffer;
g <- data.frame(from=g.from[], to=g.to[], start=g.start[], end=g.end[]);
g <- g[order(g$from, g$to, g$start),];
output <- paste("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<gexf xmlns=\"http://www.gexf.net/1.2draft\" version=\"1.2\">\n<graph mode=\"dynamic\" defaultedgetype=\"directed\" start=\"0\" end=\"", max(g$end) + decaytime, "\">\n<edges>\n", sep ="");
all.from <- as.character(unique(g$from));
for (i in 1:length(all.from))
{
	this.from <- all.from[i];
	this.to <- as.character(unique(g$to[grep(this.from, g$from)]));
	for (j in 1:length(this.to))
	{
		all.starts <- g$start[intersect(grep(this.from, g$from), grep(this.to[j], g$to))];
		all.ends <- g$end[intersect(grep(this.from, g$from), grep(this.to[j], g$to))];
		output <- paste(output, "<edge id=\"", eid, "\" source=\"", this.from, "\" target=\"", this.to[j], "\" start=\"", min(all.starts), "\" end=\"", max(all.ends), "\">\n<attvalues>\n", sep="");
		for (k in 1:length(all.starts))
		{	
			# overlap
			# if (all.starts[k+1] < all.ends[k]) output <- paste(output, "", sep=""); ... ?
			output <- paste(output, "\t<attvalue for=\"0\" value=\"1\" start=\"", all.starts[k], "\" />\n", sep="");
		}
		output <- paste(output, "</attvalues>\n<slices>\n", sep="");		
		for (l in 1:length(all.starts))
		{
			output <- paste(output, "\t<slice start=\"", all.starts[l], "\" end=\"", all.ends[l], "\" />\n", sep="");
		}
		output <- paste(output, "</slices>\n</edge>\n", sep="");	
		eid = eid + 1;
	}
} 
output <- paste(output, "</edges>\n</graph>\n</gexf>\n", sep = "");
cat(output, file=outfile.gexf);