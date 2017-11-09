# Import packages
library(twitteR)
library(magrittr)
library(tm)
library(ggplot2)
library(tidytext)
library(tidyr)
library(dplyr)

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
