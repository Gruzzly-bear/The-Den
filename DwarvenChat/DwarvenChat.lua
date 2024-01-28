-- Currently maintained, designed and updated by Gruzzly

-- Library Check
local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
if not ldb then
    error("LibDataBroker-1.1 not found.")
end

-- Create our LibDataBroker Object
local dcBroker = ldb:NewDataObject("DwarvenChat", {
    type = "data source",
    label = "Dwarven Chat",
    icon = "Interface\\AddOns\\DwarvenChat\\icon",
    text = "--"
})

-- Event Handler
local function OnEvent(self, event, addOnName)
    if event == "ADDON_LOADED" and addOnName:lower() == "dwarvenchat" then
        -- Build our slash commands
        DwarvenChat_OnLoad()

        -- set saved variables for first-time users		
        if dwarven_talk_on == nil then
            dwarven_talk_on = 1;
        end
        if dwarven_strict_on == nil then
            dwarven_strict_on = 0;
        end

        -- Get our speak tables
        if speakDB == nil then
            CreateSpeakDB()
        end

        -- set the status text of our LDB object
        dcBroker.text = dwarven_talk_on == 1 and "|c0000FF00ON |r" or "|c00FF0000OFF|r"
    elseif event == "PLAYER_LOGOUT" then

    end
    OnEvent = nil;
    self:SetScript("OnEvent", nil);
end

-- Create our frame
local dcFrame = CreateFrame("FRAME", "DwarvenChat");
dcFrame:RegisterEvent("ADDON_LOADED");
dcFrame:RegisterEvent("PLAYER_LOGOUT");
dcFrame:SetScript("OnEvent", OnEvent);

function DwarvenChat_OnLoad()
    -- Create our slash commands
    SlashCmdList["DWARVENCHATTOGGLE"] = dwarven_toggle;
    SLASH_DWARVENCHATTOGGLE1 = "/dwarvenchat";
    SLASH_DWARVENCHATTOGGLE2 = "/dchat";
    SlashCmdList["DSAY"] = dwarven_say;
    SLASH_DSAY1 = "/ds";
    SLASH_DSAY2 = "/dsay";
    SlashCmdList["DYELL"] = dwarven_yell;
    SLASH_DYELL1 = "/dy";
    SLASH_DYELL2 = "/dyell";
    SlashCmdList["DPARTY"] = dwarven_party;
    SLASH_DPARTY1 = "/dp";
    SLASH_DPARTY2 = "/dparty";
    SlashCmdList["DGUILD"] = dwarven_guild;
    SLASH_DGUILD1 = "/dg";
    SLASH_DGUILD2 = "/dguild";
    SlashCmdList["DSTRICTTOGGLE"] = dwarven_strict;
    SLASH_DSTRICTTOGGLE1 = "/dstrict";

    -- announce addon load
    if (DEFAULT_CHAT_FRAME) then
        DEFAULT_CHAT_FRAME:AddMessage("Dwarven Accent loaded!");
    end
end

-- Blizzard function to be hooked
local dwarvenChat_SendChatMessage = SendChatMessage;

-- Wintertime and Dwarf Accent conflict.
-- If we detect Wintertime, we'll note the channel and stay off of it
local wtID, wtName = GetChannelName("WinterTimeGlobal")

function SendChatMessage(msg, system, language, chatnumber)
    if (dwarven_talk_on == 1 and msg ~= "" and (string.find(msg, "%[") == nil)) then
        if (string.find(msg, "^%/") == nil) and (chatnumber ~= wtID) then
            msg = dwarvenchat(msg);
        end
    end
    dwarvenChat_SendChatMessage(msg, system, language, chatnumber);
end

function prepend_dwarven(inputString)
	local phrase_array = speakDB["dwarvenChat_PrependDB"]
	if (dwarven_strict_on == 0) then
		inputString = phrase_array[math.random(table.getn(phrase_array))]..inputString
	end
	return inputString
end

function append_dwarven(inputString)
 	local phrase_array = speakDB["dwarvenChat_AppendDB"]
	if (dwarven_strict_on == 0) then
		inputString = string.gsub(inputString, '([%.%!%?])', phrase_array[math.random(table.getn(phrase_array))].."%1",1)
	end 
	return inputString
end

function sub_dwarven(inputString)

	local cur_sub = {}
	local sub_array = speakDB["dwarvenChat_ReplaceDB"]
	
	inputString = string.gsub(inputString, "(%s)", inject_dwarven)

	for i = 1, table.getn( sub_array ) do
		cur_sub['o']=sub_array[i]['o']
		cur_sub['r']=sub_array[i]['r']
		for y = 1, table.getn(cur_sub.o) do
			local searchPtn = cur_sub.o[y]
			inputString = string.gsub(inputString, searchPtn, cur_sub.r[math.random(table.getn(cur_sub.r))])
			if ( string.find(searchPtn, "%%") == nil ) then 
				inputString = string.gsub(inputString, string.gsub(searchPtn, "%l", string.upper,1), string.gsub(cur_sub.r[math.random(table.getn(cur_sub.r))], "%l", string.upper,1))
			end
			if ( string.find(searchPtn, "%%") == nil ) then 
				inputString = string.gsub(inputString, string.gsub(searchPtn, "%l", string.upper), string.gsub(cur_sub.r[math.random(table.getn(cur_sub.r))], '%l', string.upper))
			end
		end
	end
	return inputString
end

function inject_dwarven(inputString)
	if ( math.random(100) > 98 and dwarven_strict_on == 0) then
		inputString = ", Ach, "
	end
	return inputString
end

function dwarvenchat(x)
	x = sub_dwarven(x)
	if (math.random(100) > 98 ) then
		x = append_dwarven(x)
	else
		if(math.random(100) > 98 and dwarven_strict_on == 0) then
			x = x .. " Bwaha!"
		end
	end
	if ( math.random(100) > 98 ) then
		x = prepend_dwarven(x)
	end
	return x;
end

function dwarven_toggle(toggle)
	if ( toggle == "on" ) then
		dwarven_talk_on = 1
		dcBroker.text = "|c0000FF00ON|r"
		DEFAULT_CHAT_FRAME:AddMessage("Dwarf Accent On")
	elseif ( toggle == "off" ) then
		dwarven_talk_on = 0
		dcBroker.text = "|c00FF0000OFF|r"
		DEFAULT_CHAT_FRAME:AddMessage("Dwarf Accent off")
	else	
		DEFAULT_CHAT_FRAME:AddMessage(dwarven_helptext(helptext))
	end
end

function dwarven_strict(toggle)
	if ( toggle == "on" ) then
		dwarven_strict_on = 1
		DEFAULT_CHAT_FRAME:AddMessage("Dwarven Chat append, prepend and inject phrases are off")
	elseif ( toggle == "off" ) then
		dwarven_strict_on = 0
		DEFAULT_CHAT_FRAME:AddMessage("Dwarven Chat append, prepend and inject phrases are on")
	else
		helptext = ""
		DEFAULT_CHAT_FRAME:AddMessage(dwarven_helptext(helptext))
	end
end

function dwarven_helptext(helptext)
	helptext = "/dchat (" 
	if (dwarven_talk_on == 1) then
		helptext = helptext .. "|c0000FF00on|r|off)"
	else
		helptext = helptext .. "on| |c00FF0000off|r)"
	end
	helptext = helptext .. ": toggle global dwarven talk\n/ds,/dsay: say something in Dwarven\n/dy,/dyell: yell something in Dwarven\n/dp,/dparty: party talk something in Dwarven\n/dg, /dguild: guildtalk in Dwarven\n/"
	helptext = helptext .. "dstrict ("
	if (dwarven_strict_on == 1) then
		helptext = helptext .. "|c0000FF00on|r|off)"
	else
		helptext = helptext .. "on| |c00FF0000off|r)"
	end
	helptext = helptext .. " enables/disables prepend, apend and inject phrases\n"
	return helptext
end


function dwarven_say(x)
	x = dwarvenchat(x)
	SendChatMessage(x);
end

function dwarven_yell(x)
	x = dwarvenchat(x)
	SendChatMessage(x,"YELL");
end

function dwarven_party(x)
	x = dwarvenchat(x)
	SendChatMessage(x,"PARTY");
end

function dwarven_guild(x)
	x = dwarvenchat(x)
	SendChatMessage(x,"GUILD");
end

-- LibDataBroker Functions

-- Create the LDB tooltip
function dcBroker:OnTooltipShow()
	statusLine = "Dwarven Chat is "
	if (dwarven_talk_on == 1) then
		statusLine = statusLine .. "|c0000FF00ON|r"
		if (dwarven_strict_on == 1) then
			statusLine = statusLine .. " (strict mode)"			
		else
			statusLine = statusLine .. " (verbose mode)"
		end
	else
		statusLine = statusLine .. "|c00FF0000OFF|r"
	end 
	self:AddLine(statusLine);
	self:AddLine("Left Click toggles Dwarven Chat on and off", 1, 1, 1);
    	self:AddLine("Right Click toggles betrween strict and verbose", 1, 1, 1);
    	self:AddLine(" ", 1, 1, 1);
    	self:AddLine("type: /dchat for command line options", 1, 1, 1);
   
end


-- Toggles functions based on LDB button clicks
function dcBroker:OnClick(button)
	if button== "LeftButton" then
		if (dwarven_talk_on == 1) then
			dwarven_toggle("off")
			dcBroker.text = "|c00FF0000OFF|r"
		else
			dwarven_toggle("on")
			dcBroker.text = "|c0000FF00ON |r"
		end
	elseif button== "RightButton" then
		if (dwarven_strict_on == 1) then
			dwarven_strict("off")
		else
			dwarven_strict("on")
		end
	end
end

-- Create default speak tables

function CreateSpeakDB()
	local dwarvenChat_PrependDB = {
	"Aye, ",
	}
	local dwarvenChat_AppendDB = {
	", Bwaha!",
	}
	local dwarvenChat_ReplaceDB = {
	{o={"hello","hiya","hi there","hey"}, r={"Well met","E'llo"}},
	{o={"no", "nah"}, r={"nae"}},
	{o={"No", "Nah"}, r={"Nae"}},
	{o={"the"}, r={"tha"}},
	{o={"The"}, r={"Tha"}},
	{o={"you"}, r={"ye"}},
	{o={"don't","Don't"}, r={"dunnae","Don't"}},
	{o={"my"}, r={"me"}},
	{o={"My"}, r={"Me"}},
	{o={"are"}, r={"be"}},
	{o={"Are"}, r={"Be"}},
	{o={"You"}, r={"Ye"}},
	{o={"the"}, r={"tha"}},
	{o={"The"}, r={"Tha"}},
	{o={"and"}, r={"an"}},
	{o={"And"}, r={"An"}},
    {o={"can't"}, r={"cannae"}},
    {o={"Can't"}, r={"Cannae"}},
    {o={"to"}, r={"tae"}},
    {o={"To"}, r={"Tae"}},
    {o={"of"}, r={"o'"}},
    {o={"Of"}, r={"O'"}},
    {o={"just"}, r={"jus'"}},
    {o={"Just"}, r={"Jus'"}},
	{o={"not"}, r={"nae"}},
	{o={"Not"}, r={"Nae"}},
	{o={"them"}, r={"em'"}}, 
	{o={"and"}, r={"an'"}},
	{o={"cleaning"}, r={"cleanin'"}},
    {o={"doing"}, r={"doin'"}},
    {o={"Doing"}, r={"Doin'"}},
	{o={"flying"}, r={"flyin'"}},
	{o={"fighting"}, r={"fightin'"}},
	{o={"running"}, r={"runnin'"}},
	{o={"walking"}, r={"walkin'"}},
	{o={"hunting"}, r={"huntin'"}},
    {o={"taking"}, r={"takin'"}},
    {o={"Taking"}, r={"Takin'"}},
	{o={"something"}, r={"somethin'"}},
	
	}

	speakDB = {}	

	speakDB["dwarvenChat_PrependDB"] = dwarvenChat_PrependDB
	speakDB["dwarvenChat_AppendDB"] = dwarvenChat_AppendDB
	speakDB["dwarvenChat_ReplaceDB"] = dwarvenChat_ReplaceDB


	DEFAULT_CHAT_FRAME:AddMessage("speakDB initialized");
		
end