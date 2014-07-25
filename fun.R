getDfTwi <- function (q,n,cainfo,f){
  df<-NULL
  tweetsDf<-NULL
  interval<-c("2014-07-13","2014-07-14","2014-07-15",
               "2014-07-16","2014-07-17","2014-07-18",
               "2014-07-19","2014-07-20")
  len<-length(interval)-1
  for (i in 1:len){
    tweets<-searchTwitter(q,cainfo=cainfo,n=n,lang="en",since=interval[i],until=interval[i+1],retryOnRateLimit=4)
    if(length(tweets)>0){
      tweetsDf<-twListToDF(tweets)
    }
    if(is.null(df)){
      if(!is.null(tweetsDf)){
        df<-tweetsDf
      }
    }else{
      df<-rbind(df,tweetsDf)
    }
  }
  write.csv(df,f)
  return (df)
}


readFile<-function (s){
  meta<-read.csv("data/runScoreMeta.csv")
  df = data.frame(player=NULL,position=NULL,score=NULL,performance=NULL,
                  numTweets=NULL,numRetweets=NULL,team=NULL,positionRank=NULL,overallRank=NULL)
  names(meta)
  vpos = read.csv("data/vPosTerms.csv")
  pos<- read.csv("data/posTerms.csv")
  vneg = read.csv("data/vNegTerms.csv")
  neg = read.csv("data/negTerms.csv")
  vpos<-vpos[,2]
  pos<-pos[,2]
  vneg<-vneg[,2]
  neg<-neg[,2]
 
  for (i  in 1:nrow(meta)){
    pMeta<-meta[i,]
   
    data<-read.csv(as.character(pMeta$fileSrc))
    scores<-score.sentiment(data$text,data$retweetCount,vpos,pos,neg,vneg,.progress='none')
    scores<-unique(scores)
    resultset<-scroe.weightScore(scores)
    df.sub<-data.frame(player=pMeta$player,position=pMeta$position,score=resultset$score,performance=pMeta$performance,
                       numTweets=resultset$numTweets,numRetweets=resultset$numRetweets,nation=pMeta$nation,positionRank=pMeta$positionRank
                       ,overallRank=pMeta$overallRank)
    df<-rbind(df,df.sub)
 
  }
  return (df)
}

preoarePosNegTerms<-function (){
  f<-read.delim("data/AFINN-111.txt",header=FALSE, stringsAsFactors=FALSE)
  names(f)<-c("word","score")
  vNegTerms <- f$word[f$score==-5 | f$score==-4]
  negTerms <- f$word[ f$score==-2 | f$score==-1]
  vPosTerms <- c(f$word[f$score==5 | f$score==4] ,"want","cant wait","buy","bought","look forward")
  posTerms <- c(f$word[f$score==3 | f$score==2 |f$score==1 ],"in stock")
  write.csv(vNegTerms,"data/vNegTerms.csv")
  write.csv(negTerms,"data/negTerms.csv")
  write.csv(vPosTerms,"data/vPosTerms.csv")
  write.csv(posTerms,"data/posTerms.csv")
}


