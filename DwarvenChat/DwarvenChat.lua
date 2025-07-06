-- =============================================================================
-- Dwarven Chat - Version 3.0
-- Now with a shiny Ace3 GUI!
-- =============================================================================

-- Create the addon table, making it available to options.lua
local addonName, addon = ...

-- --- Libraries ---
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local AceAddon = LibStub:GetAddon("AceAddon-3.0")
local AceDB = LibStub:GetAddon("AceDB-3.0")
local AceConfig = LibStub:GetAddon("AceConfig-3.0")
local AceConfigDialog = LibStub:GetAddon("AceConfigDialog-3.0")
local AceConsole = LibStub:GetAddon("AceConsole-3.0")

-- Create the main addon object
addon = AceAddon:NewAddon("DwarvenChat", "AceConsole-3.0")

local ON_TEXT = "|cff00FF00ON|r"
local OFF_TEXT = "|cffFF0000OFF|r"

-- --- Addon Initialization ---
function addon:OnInitialize()
    -- Define database defaults
    local dbDefaults = {
        profile = {
            talkOn = true,
            strict = false,
        }
    }
    -- Initialize the database
    self.db = AceDB:New("DwarvenChatDB", dbDefaults, true)

    -- Register the options panel from options.lua
    AceConfig:RegisterOptionsTable("DwarvenChat", self:GetOptions())
    
    -- Add the panel to Blizzard's interface options
    self.optionsFrame = AceConfigDialog:AddToBlizOptions("DwarvenChat", "Dwarven Chat")

    -- Register slash commands
    self:RegisterChatCommand("dchat", "SlashCommandHandler")
    self:RegisterChatCommand("dwarvenchat", "SlashCommandHandler")
    
    -- Setup LDB
    self:CreateLDB()
    
    -- Build the dictionary
    self:CreateSpeakDB()
    
    self:Print("Loaded! Type |cffFFFFFF/dchat|r to open the settings.")
end

-- --- Slash Command ---
function addon:SlashCommandHandler(input)
    AceConfigDialog:Open("DwarvenChat")
end

-- --- LibDataBroker (LDB) Object ---
function addon:CreateLDB()
    self.broker = LDB:NewDataObject("DwarvenChat", {
        type = "data source",
        label = "Dwarven Chat",
        icon = "Interface\\AddOns\\DwarvenChat\\icon",
        text = "--",
        OnTooltipShow = function(tooltip)
            if not tooltip or not tooltip.AddLine then return end
            tooltip:ClearLines()

            local statusLine = "Dwarven Chat is "
            if (self.db.profile.talkOn) then
                statusLine = statusLine .. ON_TEXT
                if (self.db.profile.strict) then
                    statusLine = statusLine .. " (Strict Mode)"
                else
                    statusLine = statusLine .. " (Verbose Mode)"
                end
            else
                statusLine = statusLine .. OFF_TEXT
            end
            tooltip:AddLine(statusLine)
            tooltip:AddLine(" ")
            tooltip:AddLine("|cffFFFFFFLeft-Click:|r Toggle the accent on/off.")
            tooltip:AddLine("|cffFFFFFFRight-Click:|r Toggle between Strict and Verbose modes.")
            tooltip:AddLine(" ")
            tooltip:AddLine("|cffCCCCCCShift-Click to open settings.|r")
        end,
        OnClick = function(frame, button)
            if IsShiftKeyDown() then
                self:SlashCommandHandler()
                return
            end
        
            if button == "LeftButton" then
                self:SetEnabled(nil, not self:GetEnabled())
            elseif button == "RightButton" then
                self:SetStrict(nil, not self:GetStrict())
            end
        end
    })
    self:UpdateLDB()
end

function addon:UpdateLDB()
    self.broker.text = self.db.profile.talkOn and ON_TEXT or OFF_TEXT
end


-- --- Chat Hooking ---
local original_SendChatMessage = SendChatMessage
local function Dwarven_SendChatMessage(msg, chatType, language, channel)
    if (addon.db.profile.talkOn and msg and msg ~= "" and not string.find(msg, "%[") and not string.find(msg, "^/")) then
        msg = addon:Dwarvenize(msg)
    end
    return original_SendChatMessage(msg, chatType, language, channel)
end
SendChatMessage = Dwarven_SendChatMessage


-- --- Chat Translation Logic ---
function addon:Dwarvenize(text)
    text = self:sub_dwarven(text)
    if (math.random(100) > 97) then
        text = self:append_dwarven(text)
    else
        if (math.random(100) > 97 and not self.db.profile.strict) then
            text = text .. " Hah!"
        end
    end
    if (math.random(100) > 97) then
        text = self:prepend_dwarven(text)
    end
    return text
end

function addon:inject_dwarven(inputString)
    if (math.random(100) > 98 and not self.db.profile.strict) then
        local injections = {", Ach, ", ", bah, ", ", hmph, "}
        return injections[math.random(#injections)]
    end
    return inputString
end

function addon:sub_dwarven(inputString)
    local sub_array = self.speakDB.ReplaceDB
    inputString = string.gsub(inputString, "(%s)", function(s) return self:inject_dwarven(s) end)
    for i = 1, #sub_array do
        local replacements = sub_array[i]
        for y = 1, #replacements.o do
            local searchPtn = replacements.o[y]
            local replacement = replacements.r[math.random(#replacements.r)]
            inputString = string.gsub(inputString, "(%f[%w_])"..searchPtn.."(%f[%W_])", "%1"..replacement.."%2")
            inputString = string.gsub(inputString, "(%f[%w_])"..searchPtn:gsub("^%l", string.upper).."(%f[%W_])", "%1"..replacement:gsub("^%l", string.upper).."%2")
            inputString = string.gsub(inputString, "(%f[%w_])"..searchPtn:upper().."(%f[%W_])", "%1"..replacement:upper().."%2")
        end
    end
    return inputString
end

function addon:prepend_dwarven(inputString)
    if not self.db.profile.strict then
        local phrase_array = self.speakDB.PrependDB
        inputString = phrase_array[math.random(#phrase_array)] .. inputString
    end
    return inputString
end

function addon:append_dwarven(inputString)
    if not self.db.profile.strict then
        local phrase_array = self.speakDB.AppendDB
        inputString = string.gsub(inputString, '([%.%!%?])', phrase_array[math.random(#phrase_array)] .. "%1", 1)
    end
    return inputString
end

-- --- Dwarven Dictionary ---
function addon:CreateSpeakDB()
    self.speakDB = {
        PrependDB = { "Aye, ", "By me beard, ", "Well now, ", "Listen up, ", "Blast it, ", "For Khaz Modan, " },
        AppendDB = { ", by Durin's beard!", ", yeh hear?", ", an' that's a fact!", ", bah!", ", keep yer feet on tha ground." },
        ReplaceDB = {
            {o={"hello", "hiya", "hey"}, r={"Well met", "E'llo", "How's it goin'"}},
            {o={"goodbye", "bye", "see ya"}, r={"Fare thee well", "Be seein' ye"}},
            {o={"no", "nah"}, r={"nae"}}, {o={"not"}, r={"nae"}}, {o={"can't"}, r={"cannae"}},
            {o={"don't"}, r={"dunnae"}}, {o={"is not", "isn't"}, r={"is nae"}}, {o={"do not"}, r={"dinnae"}},
            {o={"yes", "yeah"}, r={"aye"}}, {o={"the"}, r={"tha"}}, {o={"you"}, r={"ye"}},
            {o={"your"}, r={"yer"}}, {o={"my"}, r={"me"}}, {o={"are"}, r={"be"}}, {o={"and"}, r={"an'"}},
            {o={"to"}, r={"tae"}}, {o={"of"}, r={"o'"}}, {o={"just"}, r={"jus'"}}, {o={"them"}, r={"'em"}},
            {o={"with"}, r={"wi'"}}, {o={"for"}, r={"fer"}}, {o={"was"}, r={"were"}}, {o={"is"}, r={"'s"}},
            {o={"about"}, r={"'bout"}}, {o={"little"}, r={"wee"}}, {o={"friend"}, r={"lad"}},
            {o={"friends"}, r={"lads"}}, {o={"girl", "woman", "lady"}, r={"lass"}},
            {o={"boy", "man", "guy"}, r={"lad"}}, {o={"father"}, r={"da"}}, {o={"mother"}, r={"ma"}},
            {o={"elf"}, r={"pointy-ear"}}, {o={"elves"}, r={"pointy-ears"}}, {o={"gnome"}, r={"ankle-biter"}},
            {o={"goblin"}, r={"short-ear"}}, {o={"gold", "money", "cash"}, r={"coin", "gold"}},
            {o={"beer", "drink"}, r={"ale", "mead", "brew"}},
            {o={"beautiful", "pretty"}, r={"sturdy", "well-crafted"}},
            {o={"great", "awesome", "amazing"}, r={"grand", "mighty"}},
            {o={"cleaning"}, r={"cleanin'"}}, {o={"doing"}, r={"doin'"}}, {o={"flying"}, r={"flyin'"}},
            {o={"fighting"}, r={"fightin'"}}, {o={"running"}, r={"runnin'"}}, {o={"walking"}, r={"walkin'"}},
            {o={"hunting"}, r={"huntin'"}}, {o={"taking"}, r={"takin'"}}, {o={"making"}, r={"makin'"}},
            {o={"going"}, r={"goin'"}}, {o={"mining"}, r={"minin'"}}, {o={"drinking"}, r={"drinkin'"}},
            {o={"something"}, r={"somethin'"}}, {o={"nothing"}, r={"nothin'"}},
        }
    }
end