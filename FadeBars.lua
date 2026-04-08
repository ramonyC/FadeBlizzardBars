local _, FadeBlizzardBars = ...
local _G = _G
local MainActionBar = FadeBlizzardBars.ActionBarNames.MainActionBar

local inCombat = false

local function SetIsInCombat(value)
    if inCombat == value then
        return
    end

    inCombat = value
end

local function IsFadeEnabled(barKey)
    return FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "fade") == true
        and FadeBlizzardBars.Utilities.AddonEnabled() == true
end

local function IsShowOnPageChangeEnabled()
    return FadeBlizzardBars.Utilities.GetDBBarOption("mainActionBar", "additionalOptions").showOnPageChange == true
end

local function LockActionBarInCombat(barKey)
    return inCombat == true and FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showInCombat") == true
end

local function LockActionBarOnMount(barKey)
    return IsMounted() == true and FadeBlizzardBars.Utilities.GetDBBarOption(barKey, "showOnMount") == true
end

local function UpdateVisibility(page, showOnPageChange, fadeInCallback, fadeOutCallback)
    if page ~= 1 and showOnPageChange then
        fadeInCallback()
    else
        fadeOutCallback()
    end
end

local function RegisterFadeHook(bar, barKey, buttons, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.IsHookRegistered(barKey) then
        return
    end

    FadeBlizzardBars.RegisterHook(barKey)
    bar:HookScript("OnEnter", fadeInCallback)
    bar:HookScript("OnLeave", fadeOutCallback)

    for _, buttonKey in ipairs(buttons) do
        local btn = _G[buttonKey]
        if btn then
            btn:HookScript("OnEnter", fadeInCallback)
            btn:HookScript("OnLeave", fadeOutCallback)
        end
    end
end

local function RegisterCombatHook()
    if FadeBlizzardBars.IsHookRegistered("FadeCombatHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("FadeCombatHook")
    FadeBlizzardBars:RegisterEvent("PLAYER_REGEN_DISABLED", function()
        SetIsInCombat(true)
        for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
            if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showInCombat") == true then
                local bar = _G[barData.frame]
                if bar then
                    bar:SetAlpha(1)
                end
            end
        end
    end)

    FadeBlizzardBars:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        SetIsInCombat(false)
        for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
            if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showInCombat") == true then
                FadeBlizzardBars:ApplyFade(barData.key)
            end
        end
    end)
end

local function RegisterOnMountHook()
    if FadeBlizzardBars.IsHookRegistered("FadeOnMountHook") then
        return
    end

    FadeBlizzardBars.RegisterHook("FadeOnMountHook")
    FadeBlizzardBars:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED", function()
        if IsMounted() == true then
            for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
                if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showOnMount") == true then
                    local bar = _G[barData.frame]
                    if bar then
                        bar:SetAlpha(1)
                    end
                end
            end
        else
            for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
                if FadeBlizzardBars.Utilities.GetDBBarOption(barData.key, "showOnMount") == true then
                    FadeBlizzardBars:ApplyFade(barData.key)
                end
            end
        end
    end)
end

local function RegisterMainAcionBarPageWatcher(barKey, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.PageWatchers[barKey] ~= nil then
        return
    end

    local pageWatcher = CreateFrame("Frame")
    pageWatcher:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    pageWatcher:SetScript("OnEvent", function(_, _)
        UpdateVisibility(GetActionBarPage(), IsShowOnPageChangeEnabled(), fadeInCallback, fadeOutCallback)
    end)
    FadeBlizzardBars.PageWatchers[barKey] = pageWatcher
end

local function ShouldApplyFadeIn(key, bar)
    if not IsFadeEnabled(key) or LockActionBarInCombat(key) then
        return false
    end

    if inCombat == true then
        bar:SetAlpha(1)
        return false
    end

    return true
end

local function ShouldApplyFadeOut(key, bar, isMainActionBar, alpha)
    if not IsFadeEnabled(key)
        or (isMainActionBar and GetActionBarPage() ~= 1 and IsShowOnPageChangeEnabled())
        or LockActionBarInCombat(key)
        or LockActionBarOnMount(key)
        then return false
    end

    if inCombat == true then
        bar:SetAlpha(alpha or 0)
        return false
    end

    return true
end

function FadeBlizzardBars:HandleFadeBars(optionKey)
    local userProfile = self.db and self.db.profile or nil
    if not userProfile then
        return
    end

    local options = {}
    if optionKey == nil then
        options = userProfile.barOptions
    else
        options[optionKey] = userProfile.barOptions[optionKey]
    end

    RegisterCombatHook()
    RegisterOnMountHook()
    for key, option in pairs(options) do
        local barData = self.Utilities.GetBarFromCollection(key)
        local bar = _G[barData.frame]

        if bar and option.fade then
            local isMainActionBar = barData.frame == MainActionBar
            bar:SetAlpha(option.alpha or 0)
            local fadeTimer = nil

            local function FadeIn()
                if not ShouldApplyFadeIn(key, bar) then
                    return
                end

                if fadeTimer then
                    fadeTimer:Cancel()
                    fadeTimer = nil
                end

                local userOptions = FadeBlizzardBars.Utilities.GetDBBarOptions(key)
                UIFrameFadeIn(bar, userOptions.fadeSettings.fadeInTime, bar:GetAlpha(), 1)
            end

            local function FadeOut()
                if not ShouldApplyFadeOut(key, bar, isMainActionBar, option.alpha) then
                    return
                end

                local userOptions = FadeBlizzardBars.Utilities.GetDBBarOptions(key)
                fadeTimer = C_Timer.NewTimer(userOptions.fadeSettings.fadeOutDelay,
                    function()
                        UIFrameFadeOut(bar, userOptions.fadeSettings.fadeOutTime, bar:GetAlpha(), userOptions.alpha)
                        fadeTimer = nil
                    end)
            end

            RegisterFadeHook(bar, key, barData.buttons, FadeIn, FadeOut)
            if isMainActionBar == true then
                RegisterMainAcionBarPageWatcher(key, FadeIn, FadeOut)
            end
        elseif bar then
            bar:SetAlpha(1)
        end
    end
end
