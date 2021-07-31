# This is a twitter bot I put together, it pulls the credentials and sleep time from a configuration file. It then will pull the tweets either from a text file, or from the list you define below. It then will post what was tweeted in the CMD however many seconds you set the sleep time to.

import os                   # import os
import tweepy               # import twitter's api
import random               # import random
from random import randint  # import random number generator
import configparser         # import configparser
from configparser import ConfigParser
import time                 # import time
from time import sleep
import datetime
config = configparser.ConfigParser()
parser = ConfigParser()
parser.read("settings.cfg")
currentDT = datetime.datetime.now()

#Get config file from the executing directory and sets the credentials
config.read(os.path.join(os.path.dirname(__file__),"settings.cfg"))
consumer_key=config.get('settings','consumer_key')
consumer_secret=config.get('settings','consumer_secret')
access_token=config.get('settings','access_token')
access_token_secret=config.get('settings','access_token_secret')
sleep_time = int(config.get("settings", "sleep")) # sleep for 1 second by default
inputFile = 'tweet.txt'     # pull tweets from a text file 
MAX_TWEET_LENGTH = 140      # twitter max tweet length
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

# authorize the bot & get access to the API
api = tweepy.API(auth)

# start building the twitter message that will be posted
tweet = (random.choice(list(open(inputFile, encoding="utf8"))))


# post the tweet to twitter
while True:
    api.update_status(tweet)
    print(tweet + " posted at: " + currentDT.strftime('%H:%M'))
    time.sleep(sleep_time)


