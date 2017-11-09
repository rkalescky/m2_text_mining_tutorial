# Import packages
library(twitteR)
library(magrittr)
library(tm)
library(ggplot2)

# Get Twitter OAuth data
oauth <- scan("twitter_oauth.txt", character(), quote = "")

# Setup Twitter application access using OAuth
options(httr_oauth_cache=T)
setup_twitter_oauth(oauth[1], oauth[2], oauth[3], oauth[4])

# Search for tweets
tweets <- searchTwitter('#metoo', n = 1000, lang = 'en')

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

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
subset(wf, freq > 1) %>%
   ggplot(aes(word, freq)) +
   geom_bar(stat="identity", fill="darkred", colour="darkgreen") +
   theme(axis.text.x=element_text(angle=45, hjust=1))

