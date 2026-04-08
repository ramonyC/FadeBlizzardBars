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
    FadeBlizzardBars.Utilities.SetDBBarOption(barKey, barOption, value)
    FadeBlizzardBars:ApplyClickThrough(barKey)
end

local function ApplyFadeOption(barKey, barOption, value)
    FadeBlizzardBars.Utilities.SetDBBarOption(barKey, barOption, value)
    FadeBlizzardBars:ApplyFade(barKey)
end

local OptionBuilder = {
    Order = 0,
}

function OptionBuilder:ResetOrder()
    self.Order = 0
end

function OptionBuilder:BuildOption(label, type, getCallback, setCallback)
    local option = {
        order = self.Order,
    }

    self.Order = self.Order + 1

    option.name = label
    option.type = type

    if getCallback then
        option.get = getCallback
    end

    if setCallback then
        option.set = setCallback
    end

    return option
end

function OptionBuilder:BuildSlider(label, min, max, step,isPercent, getCallback, setCallback)
    local option = self:BuildOption(label, "range", getCallback, setCallback)
    option.min = min
    option.max = max
    option.step = step
    option.isPercent = isPercent

    return option
end

function OptionBuilder:BuildSpacer()
    local option = self:BuildOption(" ", "description", nil, nil)
    option.name = " "

    return option
end

function OptionBuilder:BuildSettingsGroup(label, args)
    local option = self:BuildOption(label, "group", nil, nil)
    option.inline = true
    option.args = args

    return option
end

-- Options per bar
local function GetOptionConfigArgs(barKey)
    OptionBuilder:ResetOrder()

    return {
        fade = OptionBuilder:BuildOption(FADE_LABEL, "toggle",
            function()
                return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fade")
            end,
            function(_, value)
                ApplyFadeOption(barKey, "fade", value)
            end),

        clickThrough = OptionBuilder:BuildOption(CLICK_THROUGH_LABEL, "toggle",
            function()
                return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "clickThrough")
            end,
            function(_, value)
                ApplyClickThroughOption(barKey, "clickThrough", value)
            end),

        showInCombat = OptionBuilder:BuildOption(SHOW_IN_COMBAT_LABEL, "toggle",
            function()
                return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showInCombat")
            end,
            function(_, value)
                ApplyFadeOption(barKey, "showInCombat", value)
            end),

        showOnMount = OptionBuilder:BuildOption(SHOW_ON_MOUNT_LABEL, "toggle",
            function()
                return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showOnMount")
            end,
            function(_, value)
                ApplyFadeOption(barKey, "showOnMount", value)
            end),

        alpha = OptionBuilder:BuildSlider(OPACITY_LABEL, 0, 1, 0.01, true,
            function()
                return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "alpha") or 0
            end,
            function(_, value)
                ApplyFadeOption(barKey, "alpha", value)
            end),

        spacer = OptionBuilder:BuildSpacer(),
        fadeSettings = OptionBuilder:BuildSettingsGroup(FADE_SETTINGS_LABEL, {
            fadeInTime = OptionBuilder:BuildSlider(FADE_IN_LABEL, 0, 1, 0.1,
                false,
                function()
                    return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings").fadeInTime
                end,
                function(_, value)
                    local fadeSettings = FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings")
                    fadeSettings.fadeInTime = value

                    ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                end),

            fadeOutTime = OptionBuilder:BuildSlider(FADE_OUT_LABEL, 0, 1, 0.1,
                false,
                function()
                    return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings").fadeOutTime
                end,
                function(_, value)
                    local fadeSettings = FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings")
                    fadeSettings.fadeOutTime = value

                    ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                end),

            fadeOutDelay = OptionBuilder:BuildSlider(FADE_OUT_DELAY_LABEL, 0, 5, 0.1,
                false,
                function()
                    return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings").fadeOutDelay
                end,
                function(_, value)
                    local fadeSettings = FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fadeSettings")
                    fadeSettings.fadeOutDelay = value

                    ApplyFadeOption(barKey, "fadeSettings", fadeSettings)
                end),
        }),
    }
end

-- Starts from 3 as general settings, header and bars tab take 0, 1 and 2
local ConfigBuilder = {
    Order = 3,
}

function ConfigBuilder:GetOptionGroupConfig(label, barKey, applyAdditionalOptionsCallback)
    local config = {
        name = label,
        type = "group",
        args = GetOptionConfigArgs(barKey),
    }

    config.order = self.Order
    self.Order = self.Order + 1

    if applyAdditionalOptionsCallback ~= nil then
        applyAdditionalOptionsCallback(config.args, config.order)
    end

    return config
end

local function ApplyMainBarAdditionalOptions(args, mainBarOrder)
    args.showOnPageChange = {
        name = "Show on Page Change",
        type = "toggle",
        order = mainBarOrder + 0.1,
            get = function()
                return FadeBlizzardBars.Utilities.GetDBBarOption("mainActionBar", "additionalOptions").showOnPageChange == true
            end,
            set = function(_, value)
                FadeBlizzardBars.Utilities.SetDBBarAdditionalOption("mainActionBar", "additionalOptions", "showOnPageChange", value)
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
                        return FadeBlizzardBars.Utilities.AddonEnabled()
                    end,
                    set = function(_, value)
                        FadeBlizzardBars.Utilities.SetAddonEnabled(value)
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
                    = ConfigBuilder
                        :GetOptionGroupConfig("Main Action Bar", "mainActionBar", ApplyMainBarAdditionalOptions),
                bottomLeftBarOption = ConfigBuilder:GetOptionGroupConfig("Action Bar 2", "multiBarBottomLeft"),
                bottomRightBarOption = ConfigBuilder:GetOptionGroupConfig("Action Bar 3", "multiBarBottomRight"),
                rightBarOption = ConfigBuilder:GetOptionGroupConfig("Action Bar 4", "multiBarRight"),
                leftBarOption = ConfigBuilder:GetOptionGroupConfig("Action Bar 5", "multiBarLeft"),
                multiBar5Option = ConfigBuilder:GetOptionGroupConfig("Action Bar 6", "multiBar5"),
                multiBar6Option = ConfigBuilder:GetOptionGroupConfig("Action Bar 7", "multiBar6"),
                multiBar7Option = ConfigBuilder:GetOptionGroupConfig("Action Bar 8", "multiBar7"),
                petBarOption = ConfigBuilder:GetOptionGroupConfig("Pet Action Bar", "petActionBar"),
                stanceBarOption = ConfigBuilder:GetOptionGroupConfig("Stance Bar", "stanceBar"),
                bagsBarOption = ConfigBuilder:GetOptionGroupConfig("Bags Bar", "bagsBar"),
                microMenuOption = ConfigBuilder:GetOptionGroupConfig("Micro Menu", "microMenuContainer"),
            }
        },
        profiles = nil, -- set in OnInitialize
    }
}