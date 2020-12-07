## Twitter Bot 1.0.1
# Designed, Maintained and updated by Gruzzly
# Executable included for those who wish to use it.

# 1.0.1 7/13/2020
Improved code readability

# What is it?
This small script will automatically post a line of text or an image from a folder directly onto your twitter account.<br/>
It pulls credentials and settings from a config.

# How was it made?
I used the python Tweepy module for most of it. I also used Config Parser. Config parser is great, because you can load information into the script itself after it's been compiled into an executable. I also used sleep so that it would repeat the entire process of posting after a short delay.

### ConfigParser Example
```python
consumer_key=config.get('settings','consumer_key')
consumer_secret=config.get('settings','consumer_secret')
```
### Sleep Example
```python
sleep_time = int(config.get("settings", "sleep")) # sleep for 1 second by default
```
## How to use

- The first thing you will need is a twitter account.
- Once you have that, make sure you link it to a phone number.
- This needs to be done in order to create an application on twitter's API.
- After you have a phone number linked and your account looking good, head to https://apps.twitter.com/
- Click on Create new app.
- Give it a name. Most of this information are just placeholders.
- Give it a small description.
- Set the website. You can just use a placeholder for it like this - http://website.com/
- Tick yes for developer agreement.
- After it is created, goto the key's and access token tab at the top.
- Copy the Consumer key and the consumer secret.
- Goto access token. Click generate new.
- Copy both of those tokens.
- Open up the settings.cfg with notepad.
- Input all the files as they request.
- The sleep option is how many seconds you want it to tweet. The interval. 900 = 15 mins
- After you input all the required information. Save it.
- Goto tweet.txt
- Follow the instructions in there.
- After all that is set up, run the script and watch the magic happen!






### Contact and links
- [Github](https://github.com/Gruzzly-bear)
- [Email](mailto:MB.Bowen@outlook.com?subject=Hey%20There!)
- [Website](https://gruzzly.co)

