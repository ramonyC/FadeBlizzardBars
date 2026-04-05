local _, FadeBlizzardBars = ...
local _G = _G
local MainActionBar = FadeBlizzardBars.ActionBarNames.MainActionBar

local function UpdateVisibility(page, fadeInCallback, fadeOutCallback)
    if page ~= 1 then
        fadeInCallback()
    else
        fadeOutCallback()
    end
end

local function IsFadeEnabled(barKey)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return false
    end

    local option = userProfile.barOptions[barKey]
    if not userProfile.enabled or not option then
        return false
    end

    return option.fade
end

local function RegisterFadeHook(bar, barKey, buttons, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.IsFadeHookRegistered(barKey) then
        return
    end

    FadeBlizzardBars.RegisterFadeHook(barKey)
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

local function RegisterPageWatcher(barKey, fadeInCallback, fadeOutCallback)
    if FadeBlizzardBars.PageWatchers[barKey] ~= nil then
        return
    end

    local pageWatcher = CreateFrame("Frame")
    pageWatcher:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
    pageWatcher:SetScript("OnEvent", function(_, _)
        UpdateVisibility(GetActionBarPage(), fadeInCallback, fadeOutCallback)
    end)
    FadeBlizzardBars.PageWatchers[barKey] = pageWatcher
end

FadeBlizzardBars.HandleFadeBars = function(optionKey)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    local options = {}
    if optionKey == nil then
        options = userProfile.barOptions
    else
        options[optionKey] = userProfile.barOptions[optionKey]
    end

    for key, option in pairs(options) do
        local barData = FadeBlizzardBars.GetBarByKey(key)
        local bar = _G[barData.frame]

        if bar and option.fade then
            bar:SetAlpha(option.alpha or 0)
            local fadeTimer = nil

            local function FadeIn()
                if not IsFadeEnabled(key) then
                    return
                end

                if fadeTimer then
                    fadeTimer:Cancel()
                    fadeTimer = nil
                end

                UIFrameFadeIn(bar, option.fadeSettings.fadeInTime or 0, bar:GetAlpha(), 1)
            end

            local function FadeOut()
                if not IsFadeEnabled(key) then
                    return
                end

                fadeTimer = C_Timer.NewTimer(option.fadeSettings.fadeOutDelay or 0,
                function()
                    UIFrameFadeOut(bar, option.fadeSettings.fadeOutTime or 0, bar:GetAlpha(), option.alpha or 0)
                    fadeTimer = nil
                end)
            end

            RegisterFadeHook(bar, key, barData.buttons, FadeIn, FadeOut)
            if barData.frame == MainActionBar then
                RegisterPageWatcher(key, FadeIn, FadeOut)
            end
        elseif bar then
            bar:SetAlpha(1)
        end
    end
end