## Dwarven Chat v1.0.5
# Designed, Maintained and updated by Gruzzly
Snippits and contribution by Blaquen

# 1.0.6 12/7/2020
Started development to integrate this addon into the new SHadowlands Expansion.

# 1.0.5 7/03/2020
Updated modules for new patch
Minor fixes for compatability.

# What is it?
This addon auto translates your input text and outputs modified text that resembles a dwarven accent.
## For example:
``` What are you saying? I can't hear you! ``` <br/>
becomes <br/>
``` What're ye sayin'? I cannae hear ye! ``` <br/>
This happens as soon as you press enter. It is very fast, and fluid.

# How does it work?
It creates the in game slash function on load. It creates local databases to pull and replace predefined text from.
### Creating the slash command for ingame use.
```lua
function DwarvenChat_OnLoad()

	
	SlashCmdList["DWARVENCHATTOGGLE"] = dwarven_toggle;
	SLASH_DWARVENCHATTOGGLE1 = "/dwarvenchat";
	SLASH_DWARVENCHATTOGGLE2 = "/dchat";
	SlashCmdList["DSAY"] = dwarven_say;
 ```

### Local Dwarven chat database creation for replacing words.
```lua
	local dwarvenChat_ReplaceDB = {
	{o={"^hello","^hiya","^hi there", "^hey"}, r={"Well met","E'llo"}},
	{o={"no", "nah"}, r={"nae"}},
	{o={"^no", "^nah"}, r={"^nae"}},
	{o={"the"}, r={"tha"}},
	}
```
### Hooking of blizzard function
```lua
local dwarvenChat_SendChatMessage = SendChatMessage;
```

## How to use
- Download and drop the folder into your interface/addons folder.
- tart the game and click addons in the bottom left of your screen.
- Enable Dwarven Chat
- Log in and start talkin'!

/dchat [on/off] 
toggles it on and off.  Remembered per character.

/dchat 
by itself will show you the command line help in game






### Contact and links
- [Github](https://github.com/Gruzzly-bear)
- [Email](mailto:MB.Bowen@outlook.com?subject=Hey%20There!)
- [Website](https://gruzzly.co)

