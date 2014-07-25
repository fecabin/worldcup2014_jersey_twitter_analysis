score.sentiment = function(sentences,retweetCnt, hpos.words,pos.words, neg.words, hneg.words,.progress='none')
{
  # load libraries
  require(plyr)
  require(stringr)
  require(tm)

  scores = laply(sentences, function(sentence,hpos.words,pos.words,neg.words,hneg.words) {
    # clean up sentences
   
    sentence =  str_replace_all(sentence,"[^[:graph:]]", " ")
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    # convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    # compare our words to the dictionaries of  terms
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
    # caculate the score by sum of word occurance in each type
   
    score = sum(hpos.matches) + sum(pos.matches) - sum(neg.matches)-sum(hneg.matches)
  
    
    return (score)
  
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

