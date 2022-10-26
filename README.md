# The Den

This repo is full of projects I have taken on personally or as a request for people. It includes websites I have created to further test my knowledge, Bots that I have made for friends and family, and a few misc. items here and there. Feel free to look around.

# Quick Links
- [WoW Dwarven chat addon](https://github.com/Gruzzly-bear/The-Den/tree/master/DwarvenChat)
This add-on takes text input in real time and adds a dwarven accent to it.
- [IOS Pythonista Scripts](https://github.com/Gruzzly-bear/The-Den/tree/master/IOS%20Pythonista%20sync%20scripts)
These are useful scripts to sync to and from dropbox using pythonista on IOS.
- [Twitter post bot](https://github.com/Gruzzly-bear/The-Den/tree/master/TwitterBot)
This will automatically post to twitter using their API.
- [Facebook post bot](https://github.com/Gruzzly-bear/The-Den/tree/master/Facebook%20Bot)
This will automatically post text or images to your facebook wall.
- [Twitter Image Bot](https://github.com/Gruzzly-bear/The-Den/tree/master/Twitter%20Image%20Bot)
This was created before I added both images and texts into the final Twitter bot. This bot only pulls images and posts them. Great for Advertisements.
- [Python](https://github.com/Gruzzly-bear/The-Den/tree/master/python)
This is a repo consisting of random and uncategorized python scripts.
- [Telegram Bot](https://github.com/Gruzzly-bear/The-Den/tree/master/Telegram%20Bot)
This is an unfinished Telegram bot. It was to pull from a telegram chat and post to twitter.
- [Flutter App](https://github.com/Gruzzly-bear/The-Den/tree/master/Flutter%20App)
This is an application for android that I created with Dart and Flutter for my portfolio.


### Below is a quick summary of the projects and snippits of their features.


# Flutter Portfolio App

<details>
    <summary>
    What is it?
    </summary>

<p>
An android application created for my portfolio.
</p>

The hierarchy
---

```dart
            children: [
                Image.asset(
                'assets/images/Gruzzly.png',
                width: 550,
                height: 100,
                fit: BoxFit.fitWidth,
                ),
                buttonSection,
                space,
                Image.asset(
                'assets/images/me.png',
                width: 250,
                height: 250,
                ),
                textSection,
                newtextSection,
                newtextSections
            ],
```
</details>

# Dwarven Chat

<details>
    <summary>
    What is it?
    </summary>

<p>
This addon auto translates your input text and outputs modified text that resembles a dwarven accent.
</p>

For example:
---

<p>

``` What are you saying? I can't hear you! ``` <br/>

becomes <br/>

``` What're ye sayin'? I cannae hear ye! ``` <br/>

This happens as soon as you press enter. It is very fast, and fluid.

</p>

How does it work?
---

<p> It creates the in game slash function on load. It creates local databases to pull and replace predefined text from. </p>

Creating the slash command for ingame use.
---

```lua
    function DwarvenChat_OnLoad()

        
        SlashCmdList["DWARVENCHATTOGGLE"] = dwarven_toggle;
        SLASH_DWARVENCHATTOGGLE1 = "/dwarvenchat";
        SLASH_DWARVENCHATTOGGLE2 = "/dchat";
        SlashCmdList["DSAY"] = dwarven_say;
```

Local Dwarven chat database creation for replacing words.
---

```lua
        local dwarvenChat_ReplaceDB = {
        {o={"^hello","^hiya","^hi there", "^hey"}, r={"Well met","E'llo"}},
        {o={"no", "nah"}, r={"nae"}},
        {o={"^no", "^nah"}, r={"^nae"}},
        {o={"the"}, r={"tha"}},
        }
```

Hooking of blizzard function
---

```lua
    local dwarvenChat_SendChatMessage = SendChatMessage;
```
</details>

# IOS Pythonista dropbox sync scripts.
<details>
    <summary>
    What is it?
    </summary>

    

<p>It is a set of scripts used to sync to and from Pythonista on IOS.</p>

How does it work?
---

<p>It uses your credentials from your dropbox API and then makes sure you can actually upload to it. After doing that, it will check your dropbox for any conflicts. If there is any, it will ask you how you want to handle it. Then it will push your file sto you drop box.
It will run through the same thing on the way back when you sync from your drop box.
</p>

Comparing of files locally and in the dropbox.
---

```python
    for file in folder_metadata['contents']:
        dropbox_path = file['path'][1:]
        file_name = file['path'].split('/')[-1]
            
        file_ext = os.path.splitext(file_name)[1]
            
        if file['is_dir'] --- False and (file_ext in config['file_extensions'] or [m.group(0) for l in config['file_extensions'] 
        for m in [re.match('[\.]?\*',l)] if m]):

        if not os.path.exists(os.path.join(PYTHONISTA_DOC_DIR, dropbox_path)):
```

Creation of dropbox config.
---

```python
    def setup_configuration():
        
        if not os.path.exists(SYNC_STATE_FOLDER):
            os.mkdir(SYNC_STATE_FOLDER)
        if os.path.exists(CONFIG_FILEPATH):
            with open(CONFIG_FILEPATH, 'r') as config_file:
                config = json.load(config_file)
        else:
            logging.log(FINE, 'Configuration file missing')
            config = {}
            
            logging.info('Insert your App key and secret.')
            
            config['APP_KEY'] = input('''Enter your app key
    ''')
            config['APP_SECRET'] = input('''Enter your app secret
    ''')
            
            config['ACCESS_TYPE'] = 'app_folder'
            
            
            write_configuration(config)
                
        return config
```

</details>

# Twitter Bot
<details>
    <summary>What is it?
    </summary>

<p>This small script will automatically post a line of text or an image from a folder directly onto your twitter account.<br/>
It pulls credentials and settings from a config.</p>

How was it made?
---

I used the python Tweepy module for most of it. I also used Config Parser. Config parser is great, because you can load information into the script itself after it's been compiled into an executable. I also used sleep so that it would repeat the entire process of posting after a short delay.

ConfigParser Example
---

```python
consumer_key=config.get('settings','consumer_key')
consumer_secret=config.get('settings','consumer_secret')
```

Sleep Example
---

```python
sleep_time = int(config.get("settings", "sleep")) # sleep for 1 second by default
```

</details>

# Facebook Bot

<details>
    <summary>What is it?
    </summary>
    This small script will automatically post a line of text or an image from a folder directly onto your facebook page/wall.<br/>
    It pulls credentials and settings from a config.

How does it work?
---
    I used the python module facepy to integrate the facebook API and the script together. Then I used ConfigParser to pull information from a settings config into the script.
    Then I used random and graph to post the advertisement/text pulled randomly from the file TO facebook.

ConfigParser Example
---
```python
    config.read(os.path.join(os.path.dirname(__file__),"settings.cfg"))
    ACCESS_TOKEN=config.get('settings','ACCESS_TOKEN')
```

Graph Example
---
```python
    while True:
        graph = GraphAPI(ACCESS_TOKEN)
        graph.post('me/feed', message=(random.choice(list(open('text.txt')))))
```
</details>



 









<!-- Contact and links
- [Github](https://github.com/Gruzzly-bear)
- [Email](mailto:MB.Bowen@outlook.com?subject=Hey%20There!)
- [Website](https://gruzzly.co) -->
<!-- - [Websites](https://github.com/Gruzzly-bear/The-Den/tree/master/Websites)
A small repo of websites I have worked on and are still working on. -->
