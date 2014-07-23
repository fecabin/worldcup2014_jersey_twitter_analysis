score.sentiment = function(sentences,retweetCnt, hpos.words,pos.words, neg.words, hneg.words,.progress='none')
{
  require(plyr)
  require(stringr)
  require(tm)
  # we got a vector of sentences. plyr will handle a list or a vector as an "l" for us
  # we want a simple array of scores back, so we use "l" + "a" + "ply" = laply:
  scores = laply(sentences, function(sentence,hpos.words,pos.words,neg.words,hneg.words) {
    # clean up sentences with R's regex-driven global substitute, gsub():
   
    sentence =  str_replace_all(sentence,"[^[:graph:]]", " ")
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
    hpos.matches = match(words, hpos.words)
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    hneg.matches = match(words, hneg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    hpos.matches= !is.na(hpos.matches)
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    hneg.matches= !is.na(hneg.matches)
    #print(c( hpos.matches,pos.matches,neg.matches, hneg.matches ))
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(hpos.matches)+sum(pos.matches) - 1.2*sum(neg.matches)-1.2*sum(hneg.matches)
  
    return(score)
  },hpos.words, pos.words, neg.words, hneg.words, .progress=.progress ) 
  scores.df = data.frame(score=scores,times=retweetCnt,text=sentences)
  return (scores.df)
}

scroe.weightScore= function(scores)
{
  require(data.table)
  ta<-as.data.table(scores)
  setkey(ta,score)
  ta[ta$times==0,]$times<-1
  ans<-ta[,list(sum(times)),by=score]
  weightScore<- sum(ans$score* ( (ans$V1) /sum(ans$V1)))
  return  (data.frame(score=weightScore,numTweets=nrow(scores),numRetweets=sum(ans$V1)))
}

