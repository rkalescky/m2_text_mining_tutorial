# Import packages
library(twitteR)
library(magrittr)
library(tm)
library(ggplot2)

# Setup Twitter application access using OAuth
options(httr_oauth_cache=T)
setup_twitter_oauth("nkywhHqejlG9RlvEX19WWSnPs",
"WBwKTRWp1OzL3Q9tAZXUcC1QX1lfqzYxXKe6PFr1S0wsJZEUri",
"927642335864815616-nNKPHs4rRlxeXseQYD5HSroLEhOdIZ6",
"YoUbIvZ26fhYqnfydJakgI2jj7fPwk6tRzuXmoJ1i4L2p")

# Search for tweets
tweets <- searchTwitter('#metoo', n = 1000, lang = 'en')

# Convert tweets to data.frame
df <- twListToDF(tweets)

