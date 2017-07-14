require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'sentimental'

# This is the execution instruction string.
USAGE = 'singlesearch.rb SEARCH_STRING'

# Guard clause to protect against being run with incorrect number of arguments.
if ARGV.length != 1
    puts USAGE
    exit(1)
end

# Initialize Sentimental
analyzer = Sentimental.new
analyzer.load_defaults
analyzer.threshold = 0.1

tweet_sentiment_array = []
tweet_text_array = []
username_array = []

# Constants, these never change.
BASE_SEARCH_URL= 'https://twitter.com/search?q='
SUFFIX = '&src=typd'
SEARCH_STRING = ARGV[0]

def find_general_sentiment(positives_count, negatives_count, neutrals_count)
  if positives_count > negatives_count and positives_count > neutrals_count
    return 'Positive'
  end
  
  if negatives_count > positives_count and negatives_count > neutrals_count
    return 'Negative'
  end
  
  if neutrals_count > positives_count and neutrals_count >  negatives_count
    return 'Neutral'
  end
end

doc = Nokogiri::HTML(open("#{BASE_SEARCH_URL}#{SEARCH_STRING}#{SUFFIX}/"))

js_tweet_text_container = doc.css('.js-tweet-text-container')
tweet_text = js_tweet_text_container.css('.tweet-text').text
tweet_text_array = tweet_text.split("\n")
user_handles = doc.css('.username')

tweet_text_array.zip(user_handles).each do |tweet, username|
  if username.text.length > 1
    username_array.push(username.text)
    puts username.text
  end

  if tweet.length != 0
    puts tweet
    tweet_sentiment_array.push(analyzer.sentiment(tweet))
    puts "Sentimental thinks this tweet is: #{analyzer.sentiment(tweet)}"
    puts
  end

end

negatives_count = tweet_sentiment_array.count(:negative)
positives_count = tweet_sentiment_array.count(:positive)
neutrals_count = tweet_sentiment_array.count(:neutral)

puts "Total Tweets: #{tweet_text_array.length}"
puts "Positives: #{positives_count}"
puts "Negatives: #{negatives_count}"
puts "Neutrals: #{neutrals_count}"

general_sentiment = find_general_sentiment(positives_count, negatives_count, neutrals_count)

puts "General sentiment is #{general_sentiment}"
