#Sentiment Analysis Metoo

library(tidytext)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)

##get #metoo data
metoo_df<-readRDS("/Users/karagriffin2/Desktop/metoo_df")
##Or metoo <- searchTwitter("#MeToo", n = 10000, lang="en")

# delete all retweets.  there are a lot of RT's, so in a sample  
# too small, this breaks the topic function.
metoo_df <- metoo_df %>% filter(isRetweet == FALSE)

# some other filters might be
# filter(retweetCount > 10)
# filter(favoriteCount > 10)

# tidy it up
tidy_metoo <- metoo_df %>% unnest_tokens(word, text)

tidy_metoo

#load in the built-in stopwords
data("stop_words") 

# add stop words for common technical tweet terms
#eliminate"trump" because it is not meant to be a sentiment in this context
custom_stop_words <- bind_rows(data_frame(word = c("https", "metoo", "t.co", "rt", "amp", "trump"), lexicon = c("custom")), stop_words)

# get rid of the stop words
tidy_metoo <- tidy_metoo %>% 
  anti_join(custom_stop_words) #remove the stopwords with anti_join()

#view sentiments
sentiments

#use the NRC sentiments package
#You can also use get_sentiments("bing") or get_sentiments("afinn")
get_sentiments("nrc")

##search for anger using NRC sentiments
nrcanger <- get_sentiments("nrc") %>% 
  filter(sentiment == "anger")

#produces a list of top words in "anger" category
tidy_metoo %>%
  inner_join(nrcanger) %>%
  count(word, sort = TRUE)

##visualize as a bar chart?
##not finished yet



#Separate into negative and positive columns and calculate net sentiment
##this isn't finished




#calculate most common positive and negative words using bing sentiments package
bing_word_counts <- tidy_metoo %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

bing_word_counts

#visualize
bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment",
       x = NULL) +
  coord_flip()
  