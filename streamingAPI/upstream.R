# Install and Activate Packages
install.packages("streamR")
install.packages("ROAuth")
install.packages("RCurl")
library(jsonlite)
library(streamR)
library(RCurl)
library(ROAuth)

# packages pdfs
# streamR: https://cran.r-project.org/web/packages/streamR/streamR.pdf
# ROAuth: https://cran.r-project.org/web/packages/ROAuth/ROAuth.pdf
# RCurl: https://cran.r-project.org/web/packages/RCurl/RCurl.pdf

# Request token from the api
requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "KhkwmrJAsb9RyE562dawNucCf"
consumerSecret <- "yby39ICRoCUeUIu074TIRvclwbaX9Wj7HEPhsAIN8Xfswr2Yiq"

my_oauth <- OAuthFactory$new(consumerKey = consumerKey,
                             consumerSecret = consumerSecret,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

# Save token
save(my_oauth, file= "my_oauth.RData")


# GET SAMPLE TWEEETS!!
#######################################################

# get them from the sample
sampleStream(file.name = 'sampleTweets.json',
             timeout = 60,
             tweets = 1000,
             oauth = my_oauth)

# parse tweets
sampleTweets <- parseTweets(tweets = 'sampleTweets.json', simplify=TRUE)



# GET UPSTREAM DATA
#######################################################

# filter real time data
filterStream(file.name = 'filterStream.json',
             track = c('#sinhapinew', '#sinhapi3'),
             timeout = 60,
             oauth = my_oauth)

# parse returned tweets
filterTweets <- parseTweets(tweets = 'filterStream.json')




