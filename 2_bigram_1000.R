# Import packages
library(twitteR)
library(magrittr)
library(tm)
library(ggplot2)
library(tidytext)
library(tidyr)
library(dplyr)

# Get Twitter OAuth data
oauth <- scan("twitter_oauth.txt", character(), quote = "")

# Setup Twitter application access using OAuth
options(httr_oauth_cache=T)
setup_twitter_oauth(oauth[1], oauth[2], oauth[3], oauth[4])

# Search for tweets
tweets <- searchTwitter('#metoo', n = 1000, lang = 'en')

# Convert tweets to data.frame
df <- twListToDF(tweets)

# Make bigrams
bigrams <- df %>%
   unnest_tokens(bigram, text, token = "ngrams", n = 2)

# Remove stop words
bigrams_separated <- bigrams %>%
   separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- bind_rows(data_frame(word = c("https", "metoo", "t.co", "rt", "amp"),lexicon = c("custom")), stop_words)  

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)

# Count bigrams
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

# View bigrams
head(bigram_counts)
