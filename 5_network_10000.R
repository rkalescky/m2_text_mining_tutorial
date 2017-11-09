##Network with bigrams

library(igraph)
library(ggraph)

metoo <- searchTwitter("#MeToo", n = 1000, lang="en")

#use this to create dataframe
metoo_df <- twListToDF(metoo)

##OR metoo_df<-readRDS("/Users/karagriffin2/Desktop/metoo_df")

View(metoo_df)

# delete all retweets.  there are a lot of RT's, so in a sample  
# too small, this breaks the topic function.
metoo_df <- metoo_df %>% filter(isRetweet == FALSE)

# some other filters might be
# filter(retweetCount > 10)
# filter(favoriteCount > 10)

# tidy it up and make it a bigram
tidy_metoo <- metoo_df %>%  unnest_tokens(bigram, text, token = "ngrams", n = 2)

tidy_metoo

tidy_metoo %>%
  count(bigram, sort = TRUE)

##trying to eliminate stop words. not working
bigrams_separated <- tidy_metoo %>%
  separate(bigram, c("word1", "word2"), sep = " ")

custom_stop_words <- bind_rows(data_frame(word = c("https", "metoo", "t.co", "rt", "amp"),lexicon = c("custom")), stop_words)  

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% custom_stop_words$word) %>%
  filter(!word2 %in% custom_stop_words$word)
  

# new bigram counts:
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

bigram_counts

View(bigram_counts)


# filter for only relatively common combinations
bigram_graph <- bigram_counts %>%
  filter(n > 15) %>%
  graph_from_data_frame()

bigram_graph

set.seed(2017)

#Visualize
ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)