# Topic Modeling

#load these libraries
library(tidytext)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)
library(twitteR)
library(ROAuth)

##authenticate Twitter app
api_key <- "xxxxxxxxxxxxxxxxxxxxx"

api_secret <- "xxxxxxxxxxxxxxxxxx"

access_token <- "xxxxxxxxxxxxxxxx"

access_token_secret <- "xxxxxxxxxxxxxxx"

options(httr_oauth_cache=T)
setup_twitter_oauth(api_key,api_secret, access_token, access_token_secret)


# searchTwitter is the TwitteR search function. 
# we're looking for english language tweets
metoo <- searchTwitter("#MeToo", n = 10000, lang="en")
### Or load from a saved file: metoo_df<-readRDS("/Users/karagriffin2/Desktop/metoo_df")


#use this to create dataframe
metoo_df <- twListToDF(metoo)

#view the dataframe
View(metoo_df)


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
custom_stop_words <- bind_rows(data_frame(word = c("https", "metoo", "t.co", "rt", "amp"), lexicon = c("custom")), stop_words)

# get rid of the stop words
tidy_metoo <- tidy_metoo %>% 
  anti_join(custom_stop_words) #remove the stopwords with anti_join()

# count the top words
metoo.word.count <- tidy_metoo %>% count(word, sort=TRUE) %>%
  ungroup() 
metoo.word.count

# graph the top words
metoo.word.count %>%
  mutate(word=reorder(word,n)) %>% # reorder by word
  filter(n > 75) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  coord_flip() # swap the axes

# create a document term matrix for topic modeling
metoo_dtm <- tidy_metoo %>% count(id, word, sort = TRUE) %>%
  cast_dtm(id, word, n) 

# create a topic model with 8 topics
metoo_lda <- LDA(metoo_dtm, k = 8, control = list(seed = 1234))

#look at it
metoo_lda
# this is a topic model, but it isn't easy-to-read-version yet.

# show the topic-term probabilities ("beta")
metoo_topics <- tidy(metoo_lda, matrix = "beta")
# tidy() extracts the beta probabilities from a topic model into a tidy format
# beta is the topic-term probabilities
metoo_topics

# grab the top 10 terms in each topic
top_terms <- metoo_topics %>%
  group_by(topic) %>% # group by topic
  top_n(10, beta) %>% # take the top 10 by their beta probability
  ungroup() %>% #ungroup
  arrange(topic, -beta) # sort in order of descending beta for each topic

# look at the top 5 terms in each topic
top_terms

# plot a bar chart of the top terms for each topic
top_terms %>%
  mutate(term = reorder(term, beta)) %>% 
  # reorder the term column by beta
  ggplot(aes(term, beta, fill = factor(topic))) + 
  # term on the x axis, beta on the y, color the bars by topic
  geom_col(show.legend = FALSE) +
  # a bar plot
  facet_wrap(~ topic, scales = "free") +
  # one graph for each topic. let the y scales be different in each one.
  coord_flip()
# now put the x axis(terms) on the vertical plane so we can read it



