--[[
	MIT License
	Copyright (c) 2026, Vitaliy "Ramony" Chernishev < chernush.vitaly at gmail dot com >
	See LICENSE for details.
]]

local _, FadeBlizzardBars = ...
FadeBlizzardBars = LibStub("AceAddon-3.0"):NewAddon(FadeBlizzardBars, "FadeBlizzardBars");
_G.FadeBlizzardBars = FadeBlizzardBars

function FadeBlizzardBars:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("FadeBlizzardBarsDB", FadeBlizzardBars.DbDefaults)
    if self.db.profile.enabled then
        FadeBlizzardBars:EnableAddon()
    end

    print("|cff00ff00FadeBlizzardBars:|r Available commands: |cff00ffff/fbb on|r to enable," ..
    " |cff00ffff/fbb off|r to disable, |cff00ffff/fbb|r to configure")
end

SLASH_FBB1 = "/fbb"
SlashCmdList["FBB"] = function(msg)
    if msg == "off" then
        FadeBlizzardBars:DisableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Disabled")
    elseif msg == "on" then
        FadeBlizzardBars:EnableAddon()
        print("|cff00ff00FadeBlizzardBars:|r Enabled")
    else
        LibStub("AceConfigDialog-3.0"):Open("FadeBlizzardBars")
    end
end

local CLICK_THROUGH_LABEL = "Click Through"
local FADE_LABEL = "Fade"
local OPACITY_LABEL = "Opacity"

local function ApplyClickThroughOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    if FadeBlizzardBars.IsEnabled() then
        FadeBlizzardBars:ApplyClickThrough()
    end
end

local function ApplyFadeOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    if FadeBlizzardBars.IsEnabled() then
        FadeBlizzardBars:ApplyFade()
    end
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
        alpha = {
            name = OPACITY_LABEL,
            type = "range",
            order = 2,
            min = 0,
            max = 1,
            step = 0.01,
            isPercent = true,
            get = function()
                return FadeBlizzardBars.GetBarOption(barKey, "alpha") or 0
            end,
            set = function(_, value)
                ApplyFadeOption(barKey, "alpha", value)
            end,
        },
    }
end

local function GetOptionGroupConfig(label, barKey, order)
    return {
        name = label,
        type = "group",
        args = GetOptionConfigArgs(barKey),
        order = order,
    }
end

-- Options dialog
local options = {
    name = "FadeBlizzardBars",
    type = "group",
    childGroups = "tree",
    args = {
        configOptions = {
            name = "General settings",
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
        mainBarOption = GetOptionGroupConfig("Main Action Bar", "mainActionBar", 3),
        bottomLeftBarOption = GetOptionGroupConfig("Bottom Left Action Bar", "multiBarBottomLeft", 4),
        bottomRightBarOption = GetOptionGroupConfig("Bottom Right Action Bar", "multiBarBottomRight", 5),
        rightBarOption = GetOptionGroupConfig("Right Action Bar", "multiBarRight", 6),
        leftBarOption = GetOptionGroupConfig("Left Action Bar", "multiBarLeft", 7),
        multiBar5Option = GetOptionGroupConfig("Multi Bar 5", "multiBar5", 8),
        multiBar6Option = GetOptionGroupConfig("Multi Bar 6", "multiBar6", 9),
        multiBar7Option = GetOptionGroupConfig("Multi Bar 7", "multiBar7", 10),
        petBarOption = GetOptionGroupConfig("Pet Action Bar", "petActionBar", 11),
        stanceBarOption = GetOptionGroupConfig("Stance Bar", "stanceBar", 12),
        bagsBarOption = GetOptionGroupConfig("Bags Bar", "bagsBar", 13),
        microMenuOption = GetOptionGroupConfig("Micro Menu", "microMenuContainer", 14),
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("FadeBlizzardBars", options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FadeBlizzardBars", "FadeBlizzardBars")
