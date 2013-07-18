#@jbreen@cambridge.aero
#@June 2011
# http://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/

#~~~~~~~~~~~~~load the package and scape data~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
library(twitteR)
# get the 1,500 most recent tweets mentioning ??@delta?бе:
delta.tweets = searchTwitter('@delta', n=150)
american.tweets = searchTwitter('@AmericanAir', n=150)
# note @AmericanAir is the account of american airlines
delta.text = laply(delta.tweets, function(t) t$getText() )
american.text = laply(american.tweets, function(t) t$getText() )
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sentiment-analysis~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# Download Hu & Liu?беs opinion lexicon:
# http://www.cs.uic.edu/~liub/FBS/sentiment-analysis.html
# Loading data
hu.liu.pos = scan(file='D:/Micro-blog/twitter/Mining twitter using R/positive-words.txt',
    what='character', comment.char=';')
hu.liu.neg = scan(file='D:/Micro-blog/twitter/Mining twitter using R/negative-words.txt',
    what='character', comment.char=';')
# Add a few industry-specific and/or especially emphatic terms:
pos.words = c(hu.liu.pos, 'upgrade')
neg.words = c(hu.liu.neg, 'wtf', 'wait','waiting', 'epicfail', 'mechanical')
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
    require(plyr)
    require(stringr)
 
    # we got a vector of sentences. plyr will handle a list
    # or a vector as an "l" for us
    # we want a simple array ("a") of scores back, so we use
    # "l" + "a" + "ply" = "laply":
    scores = laply(sentences, function(sentence, pos.words, neg.words) {
 
        # clean up sentences with R's regex-driven global substitute, gsub():
        sentence = gsub('[[:punct:]]', '', sentence)
        sentence = gsub('[[:cntrl:]]', '', sentence)
        sentence = gsub('\\d+', '', sentence)
        # and convert to lower case:
        sentence = tolower(sentence)
 
        # split into words. str_split is in the stringr package
        word.list = str_split(sentence, '\\s+')
        # sometimes a list() is one level of hierarchy too much
        words = unlist(word.list)
 
        # compare our words to the dictionaries of positive & negative terms
        pos.matches = match(words, pos.words)
        neg.matches = match(words, neg.words)
 
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches = !is.na(pos.matches)
        neg.matches = !is.na(neg.matches)
 
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        score = sum(pos.matches) - sum(neg.matches)
 
        return(score)
    }, pos.words, neg.words, .progress=.progress )
 
    scores.df = data.frame(score=scores, text=sentences)
    return(scores.df)
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~test~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
sample = c("You're awesome and I love you",
     "I hate and hate and hate. So angry. Die!",
     "Impressed and amazed: you are peerless in your achievement of unparalleled mediocrity.")##
result = score.sentiment(sample, pos.words, neg.words)
result$score
result[c(1,3), 'score']
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~data processing~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
delta.scores = score.sentiment(head(delta.text,60), pos.words,neg.words, .progress='text')
delta.scores$score
delta.scores$airline = 'Delta'
 
american.scores = score.sentiment(head(american.text,60), pos.words,neg.words, .progress='text')
american.scores$score
american.scores$airline = 'American'

hist(delta.scores$score)
library(ggplot2)
qplot(delta.scores$score)
# to run the following model, you need to grab the data like delta.scores.
all.scores = rbind( american.scores,  delta.scores)

ggplot(data=all.scores) + # ggplot works on data.frames, always
geom_bar(mapping=aes(x=score, fill=airline), binwidth=1) +
facet_grid(airline~.) + # make a separate plot for each airline
theme_bw() + scale_fill_brewer() # plain display, nicer colors


