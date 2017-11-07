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
tweets <- searchTwitter('#metoo', n = 100, lang = 'en')

# Convert tweets to data.frame
df <- twListToDF(tweets)

# Get just the tweet text as list
tweet_text <- df[,"text"]

# Convert to corpus object
text_corpus = Corpus(VectorSource(tweet_text))

# Generate document-term matrix
dtm <- DocumentTermMatrix(text_corpus,
   control = list(
      stopwords = stopwords("english")
      removePunctuation = TRUE,
      removeNumbers = TRUE,
      tolower = TRUE))

# 
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
subset(wf, freq > 1)    %>%
   ggplot(aes(word, freq)) +
   geom_bar(stat="identity", fill="darkred", colour="darkgreen") +
   theme(axis.text.x=element_text(angle=45, hjust=1))

