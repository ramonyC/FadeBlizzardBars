--[[
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	All rights reserved.
]]

local _, FadeBlizzardBars = ...
FadeBlizzardBars = LibStub("AceAddon-3.0"):NewAddon(FadeBlizzardBars, "FadeBlizzardBars");
_G.FadeBlizzardBars = FadeBlizzardBars

function FadeBlizzardBars:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("FadeBlizzardBarsDB", FadeBlizzardBars.DbDefaults, true)
    if self.db.profile.enabled then
        FadeBlizzardBars:EnableAddon()
    end

    print("|cff00ff00FadeBlizzardBars:|r Available commands: |cff00ffff/fbb on|r to enable, |cff00ffff/fbb off|r to disable, |cff00ffff/fbb options|r to open options")
end

SLASH_FBB1 = "/fbb"
SlashCmdList["FBB"] = function(msg)
    if msg == "off" then
        FadeBlizzardBars:DisableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Disabled")
    elseif msg == "on" then
        FadeBlizzardBars:EnableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Enabled")
    elseif msg == "options" then
        LibStub("AceConfigDialog-3.0"):Open("FadeBlizzardBars")
    else
        print("|cff00ff00FadeBlizzardBars:|r /fbb on | /fbb off | /fbb options")
    end
end

local CLICK_THROUGH_LABEL = "Click Through"
local FADE_LABEL = "Fade"

local function ApplyClickThroughOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    FadeBlizzardBars:ApplyClickThrough()
end

local function ApplyFadeOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    FadeBlizzardBars:ApplyFade()
end

-- Options per bar
local function GetOptionConfigArgs(barKey)
return {
        fade = {
            name = FADE_LABEL,
            type = "toggle",
            order = 0,
            get = function()
                return FadeBlizzardBars.GetBarOption(barKey, "fade")
            end,
            set = function(_, value)
                ApplyFadeOption(barKey, "fade", value)
            end,
        },
        clickThrough = {
            name = CLICK_THROUGH_LABEL,
            type = "toggle",
            order = 1,
            get = function()
                return FadeBlizzardBars.GetBarOption(barKey, "clickThrough")
            end,
            set = function(_, value)
                ApplyClickThroughOption(barKey, "clickThrough", value)
            end,
        },
    }
end

local function GetOptionConfig(label, barKey, order)
    return {
        name = label,
        type = "group",
        inline = true,
        args = GetOptionConfigArgs(barKey),
        order = order,
    }
end

-- Options dialog
local options = {
    name = "FadeBlizzardBars",
    type = "group",
    args = {
        header = {
            name = "FadeBlizzardBars",
            type = "header",
            order = 0,
        },
        configOptions = {
            name = "",
            type = "group",
            inline = true,
            order = 1,
            args = {
                enabled = {
                    name = "Enabled",
                    type = "toggle",
                    order = 0,
                    width = "double",
                    get = function()
                        return FadeBlizzardBars.IsEnabled()
                    end,
                    set = function(_, value)
                        FadeBlizzardBars.SetIsEnabled(value)
                        if value then
                            FadeBlizzardBars:EnableAddon()
                        else
                            FadeBlizzardBars:DisableAddon()
                        end
                    end,
                },
                resetButton = {
                    name = "Reset to defaults",
                    type = "execute",
                    order = 1,
                    confirm = true,
                    confirmText = "This action will reset all configured data. Proceed?",
                    func = function()
                        FadeBlizzardBarsDB = nil
                        ReloadUI()
                    end,
                },
            },
        },
        actionBarOptionsHeader = {
            name = "Action Bar toggles",
            type = "header",
            order = 2,
        },
        mainBarOption = GetOptionConfig("Main Action Bar", "mainActionBar", 3),
        bottomLeftBarOption = GetOptionConfig("Bottom Left Action Bar", "multiBarBottomLeft", 4),
        bottomRightBarOption = GetOptionConfig("Bottom Right Action Bar", "multiBarBottomRight", 5),
        rightBarOption = GetOptionConfig("Right Action Bar", "multiBarRight", 6),
        leftBarOption = GetOptionConfig("Left Action Bar", "multiBarLeft", 7),
        multiBar5Option = GetOptionConfig("Multi Bar 5", "multiBar5", 8),
        multiBar6Option = GetOptionConfig("Multi Bar 6", "multiBar6", 9),
        multiBar7Option = GetOptionConfig("Multi Bar 7", "multiBar7", 10),
        petBarOption = GetOptionConfig("Pet Action Bar", "petActionBar", 11),
        stanceBarOption = GetOptionConfig("Stance Bar", "stanceBar", 12),
        bagsBarOption = GetOptionConfig("Bags Bar", "bagsBar", 13),
        microMenuOption = GetOptionConfig("Micro Menu", "microMenuContainer", 14),
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("FadeBlizzardBars", options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FadeBlizzardBars", "FadeBlizzardBars")