
========================================================


```r
library(twitteR)
```

```
## Loading required package: ROAuth
## Loading required package: RCurl
## Loading required package: bitops
## Loading required package: digest
## Loading required package: rjson
```

```r
library(ROAuth)
library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following object is masked from 'package:twitteR':
## 
##     id
```

```r
library(stringr)
library(ggplot2)
```


You can also embed plots, for example:


```r
# download.file(url='http://curl.haxx.se/ca/cacert.pem',destfile='cacert.pem')
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "http://api.twitter.com/oauth/access_token"
authURL <- "http://api.twitter.com/oauth/authorize"
consumerKey <- "PHCMkFscXg8b2PsLR5WuLu30I"
consumerSecret <- "0be83YNqZ2UCXVknPbLvaQPLBq5n403ZGTTCG00ESzN123jMrr"
Cred <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
    requestURL = requestURL, accessURL = accessURL, authURL = authURL)
Cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
```

```
## To enable the connection, please direct your web browser to: 
## http://api.twitter.com/oauth/authorize?oauth_token=M8B6vNCMidQJlwuD4Ifa5dK7tHeDTwJ6kIN6V5D1A
## When complete, record the PIN given to you and provide it here:
```

```
## Error: Forbidden
```

```r
registerTwitterOAuth(Cred)
```

```
## Error: oauth has not completed its handshake
```

```r

662858
```

```
## [1] 662858
```

```r
save(Cred, file = "twitter authentication.Rdata")
load("twitter authenication.Rdata")
```

```
## Warning: 無法開啟壓縮過的檔案 'twitter authenication.Rdata'，可能的原因是
## 'No such file or directory'
```

```
## Error: 無法開啟連結
```

```r
registerTwitterOAuth(Cred)
```

```
## Error: oauth has not completed its handshake
```


