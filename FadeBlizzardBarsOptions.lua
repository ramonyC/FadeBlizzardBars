local _, FadeBlizzardBars = ...

local CLICK_THROUGH_LABEL = "Click Through"
local FADE_LABEL = "Fade"
local OPACITY_LABEL = "Opacity"
local FADE_SETTINGS_LABEL = "Fade Settings"
local FADE_IN_LABEL = "Fade In Time"
local FADE_OUT_LABEL = "Fade Out Time"
local FADE_OUT_DELAY_LABEL = "Fade Out Delay"
local SHOW_IN_COMBAT_LABEL = "Show in Combat"
local SHOW_ON_MOUNT_LABEL = "Show on Mount"

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
        showInCombat = {
            name = SHOW_IN_COMBAT_LABEL,
            type = "toggle",
            order = 2,
            get = function()
                return FadeBlizzardBars.GetBarOption(barKey, "showInCombat")
            end,
            set = function(_, value)
                ApplyFadeOption(barKey, "showInCombat", value)
            end,
        },
        showOnMount = {
            name = SHOW_ON_MOUNT_LABEL,
            type = "toggle",
            order = 3,
            get = function()
                return FadeBlizzardBars.GetBarOption(barKey, "showOnMount")
            end,
            set = function(_, value)
                ApplyFadeOption(barKey, "showOnMount", value)
            end,
        },
        alpha = {
            name = OPACITY_LABEL,
            type = "range",
            order = 4,
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
        spacer = GetSpacer(5),
        fadeSettings = {
            name = FADE_SETTINGS_LABEL,
            type = "group",
            inline = true,
            order = 5,
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

local function GetOptionGroupConfig(label, barKey, order, applyAdditionalOptionsCallback)
    local config = {
        name = label,
        type = "group",
        args = GetOptionConfigArgs(barKey),
        order = order,
    }

    if applyAdditionalOptionsCallback ~= nil then
        applyAdditionalOptionsCallback(config.args)
    end

    return config
end

local function ApplyMainBarAdditionalOptions(args)
    args.showOnPageChange = {
        name = "Show on Page Change",
        type = "toggle",
        order = 3.5,
            get = function()
                return FadeBlizzardBars.GetBarOption("mainActionBar", "additionalOptions").showOnPageChange == true
            end,
            set = function(_, value)
                FadeBlizzardBars.SetBarAdditionalOption("mainActionBar", "additionalOptions", "showOnPageChange", value)
            end
        }
end

-- Options dialog
FadeBlizzardBars.OptionsConfig = {
    name = "FadeBlizzardBars",
    type = "group",
    childGroups = "tab",
    args ={
        general = {
            name = "General settings",
            type = "group",
            inline = true,
            order = 0,
            args = {
                enabled = {
                    name = "Enabled",
                    type = "toggle",
                    order = 0,
                    width = "half",
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
            },
        },
        actionBarOptionsHeader = {
            name = "Action Bar toggles",
            type = "header",
            order = 1,
        },
        bars = {
            name = "Bars",
            type = "group",
            childGroups = "tree",
            order = 2,
            args = {
                mainBarOption
                    = GetOptionGroupConfig("Main Action Bar", "mainActionBar", 3, ApplyMainBarAdditionalOptions),
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
            }
        },
        profiles = nil, -- set in OnInitialize
    }
}