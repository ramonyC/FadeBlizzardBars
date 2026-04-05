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
local FADE_SETTINGS_LABEL = "Fade Settings"
local FADE_IN_LABEL = "Fade In Time"
local FADE_OUT_LABEL = "Fade Out Time"
local FADE_OUT_DELAY_LABEL = "Fade Out Delay"

local function ApplyClickThroughOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    if FadeBlizzardBars.IsEnabled() then
        FadeBlizzardBars:ApplyClickThrough(barKey)
    end
end

local function ApplyFadeOption(barKey, barOption, value)
    FadeBlizzardBars.SetBarOption(barKey, barOption, value)
    if FadeBlizzardBars.IsEnabled() then
        FadeBlizzardBars:ApplyFade(barKey)
    end
end

local function GetSpacer(order)
    return {
        name = " ",
        type = "description",
        order = order,
    }
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
        spacer = GetSpacer(3),
        fadeSettings = {
            name = FADE_SETTINGS_LABEL,
            type = "group",
            inline = true,
            order = 4,
            args = {
                fadeInTime = {
                    name = FADE_IN_LABEL,
                    type = "range",
                    order = 0,
                    min = 0,
                    max = 1,
                    step = 0.1,
                    get = function()
                        return FadeBlizzardBars.GetBarOption(barKey, "fadeSettings").fadeInTime
                    end,
                    set = function(_, value)
                        local fadeSettings = FadeBlizzardBars.GetBarOption(barKey, "fadeSettings")
                        fadeSettings.fadeInTime = value

                        ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                    end,
                },
                fadeOutTime = {
                    name = FADE_OUT_LABEL,
                    type = "range",
                    order = 1,
                    min = 0,
                    max = 1,
                    step = 0.1,
                    get = function()
                        return FadeBlizzardBars.GetBarOption(barKey, "fadeSettings").fadeOutTime
                    end,
                    set = function(_, value)
                        local fadeSettings = FadeBlizzardBars.GetBarOption(barKey, "fadeSettings")
                        fadeSettings.fadeOutTime = value

                        ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                    end,
                },
                fadeOutDelay = {
                    name = FADE_OUT_DELAY_LABEL,
                    type = "range",
                    order = 2,
                    min = 0,
                    max = 5,
                    step = 0.1,
                    get = function()
                        return FadeBlizzardBars.GetBarOption(barKey, "fadeSettings").fadeOutDelay
                    end,
                    set = function(_, value)
                        local fadeSettings = FadeBlizzardBars.GetBarOption(barKey, "fadeSettings")
                        fadeSettings.fadeOutDelay = value

                        ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                    end,
                },
            },
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
                    name = "Reset settings",
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
        bottomLeftBarOption = GetOptionGroupConfig("Action Bar 2", "multiBarBottomLeft", 4),
        bottomRightBarOption = GetOptionGroupConfig("Action Bar 3", "multiBarBottomRight", 5),
        rightBarOption = GetOptionGroupConfig("Action Bar 4", "multiBarRight", 6),
        leftBarOption = GetOptionGroupConfig("Action Bar 5", "multiBarLeft", 7),
        multiBar5Option = GetOptionGroupConfig("Action Bar 6", "multiBar5", 8),
        multiBar6Option = GetOptionGroupConfig("Action Bar 7", "multiBar6", 9),
        multiBar7Option = GetOptionGroupConfig("Action Bar 8", "multiBar7", 10),
        petBarOption = GetOptionGroupConfig("Pet Action Bar", "petActionBar", 11),
        stanceBarOption = GetOptionGroupConfig("Stance Bar", "stanceBar", 12),
        bagsBarOption = GetOptionGroupConfig("Bags Bar", "bagsBar", 13),
        microMenuOption = GetOptionGroupConfig("Micro Menu", "microMenuContainer", 14),
    },
}

LibStub("AceConfig-3.0"):RegisterOptionsTable("FadeBlizzardBars", options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FadeBlizzardBars", "FadeBlizzardBars")
