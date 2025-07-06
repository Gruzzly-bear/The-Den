local addonName, addon = ...

-- This function defines the structure of the settings panel.
function addon:GetOptions()
    -- Create the options table only once.
    if addon.options then return addon.options end

    local options = {
        name = "Dwarven Chat",
        handler = addon,
        type = "group",
        args = {
            header = {
                order = 1,
                type = "header",
                name = "|cffA52A2ADwarven Chat Settings|r",
            },
            desc = {
                 order = 2,
                 type = "description",
                 name = "Configure yer dwarven accent just the way ye like it. Keep yer feet on tha ground!\n",
                 fontSize = "medium",
            },
            -- General settings group
            general = {
                order = 10,
                type = "group",
                name = "Main Controls",
                guiInline = true,
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = "Enable Dwarven Accent",
                        desc = "Globally turns the dwarven translation on or off.",
                        get = "GetEnabled",
                        set = "SetEnabled",
                    },
                    strict = {
                        order = 2,
                        type = "toggle",
                        name = "Strict Mode",
                        desc = "If enabled, only direct word replacements are made.\n|cffCCCCCCDisables random injections and phrases like 'By me beard!' for a cleaner, less verbose translation.|r",
                        get = "GetStrict",
                        set = "SetStrict",
                    },
                },
            },
            about = {
                order = 20,
                type = "group",
                name = "About",
                guiInline = true,
                args = {
                     desc = {
                        order = 1,
                        type = "description",
                        name = "Original by Gruzzly, Reforged by Gemini.",
                        fontSize = "small",
                    },
                }
            }
        },
    }
    addon.options = options
    return options
end

-- Getter and Setter functions for the options table
function addon:GetEnabled()
    return self.db.profile.talkOn
end

function addon:SetEnabled(info, value)
    self.db.profile.talkOn = value
    self:UpdateLDB()
    self:Print("Dwarven Chat is now " .. (value and "|cff00FF00ON|r" or "|cffFF0000OFF|r"))
end

function addon:GetStrict()
    return self.db.profile.strict
end

function addon:SetStrict(info, value)
    self.db.profile.strict = value
    self:UpdateLDB()
    self:Print("Dwarven Chat Strict Mode is now " .. (value and "|cff00FF00ON|r" or "|cffFF0000OFF|r"))
end