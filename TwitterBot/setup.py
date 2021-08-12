from distutils.core import setup # Need this to handle modules
import py2exe 
import os                   # import os
import tweepy               # import twitter's api
import random               # import random
from random import randint  # import random number generator
import configparser         # import configparser
from configparser import ConfigParser
import time                 # import time
from time import sleep
import datetime

setup(console=['bot.py'])