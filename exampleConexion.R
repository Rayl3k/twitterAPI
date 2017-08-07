# install.packages("twitteR")
require(twitteR)

# api tutorial
# https://medium.com/@GalarnykMichael/accessing-data-from-twitter-api-using-r-part1-b387a1c7d3e

# package documentation
# https://cran.r-project.org/web/packages/twitteR/twitteR.pdf


# Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret. 
consumer_key <- "KhkwmrJAsb9RyE562dawNucCf"
consumer_secret <- "yby39ICRoCUeUIu074TIRvclwbaX9Wj7HEPhsAIN8Xfswr2Yiq"
access_token <- "224395809-686zlx71L85rAsVcnl54hkP2AQeTXAYcyeOz17jU"
access_secret <- "hIG2BvMAHRFuGOt9jv3HAKDMap25jq9RmZoO9Qwto0azL"

# launch search
getCurRateLimitInfo()
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tw = twitteR::searchTwitter('#tourTVE', n = 1e4, since = '2017-07-01', retryOnRateLimit = 1e3)
dt = twitteR::twListToDF(tw)

# backupdata
write.csv(dt, file='tourTVE.csv', row.names = FALSE)

library(dplyr)
library(tidyr)
library(ggplot2)
names(dt)

dd <- select(dt, c(1,5,8,11,12,13))
dd <- mutate(dd, date=strftime(created, format='%Y-%m-%d'), 
             hour=strftime(created, format='%H'), 
             minute=strftime(created, format='%M'),
             hourMinute=strftime(created, format='%H:%M'))
dd$date <- as.Date(dd$date, format='%Y-%m-%d')
dd$hour <- as.integer(dd$hour)
dd$minute <- as.integer(dd$minute)
dd$hourMinute <- as.factor(dd$hourMinute)
dd$halfHour <- ifelse(dd$minute >= 30, paste(dd$hour, '30', sep=':'), paste(dd$hour, '00', sep=':'))
dd$halfHour <- as.factor(dd$halfHour)


# tryouts sorting data
tday <- group_by(dd, date) %>% summarise(tweets=n()) %>% arrange(date)

# filter only 3/4 relevant dates
activity <- filter(dd, date >= '2017-07-21' & date <= '2017-07-23') %>%
  group_by(date, halfHour) %>% summarise(tweets=n())

ggplot(activity, aes(x=as.factor(halfHour), y=tweets, group=date, colour=as.factor(date))) + geom_line() + geom_point()