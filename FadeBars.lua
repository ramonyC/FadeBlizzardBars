local _, FadeBlizzardBars = ...
local _G = _G
local MainActionBar = FadeBlizzardBars.ActionBarNames.MainActionBar

local function UpdateVisibility(page, fadeInCallback, fadeOutCallback)
    if page == 2 then
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

FadeBlizzardBars.HandleFadeBars = function()
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    for key, option in pairs(userProfile.barOptions) do
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

            if barData.frame == MainActionBar then
                local pageWatcher = CreateFrame("Frame")
                pageWatcher:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
                pageWatcher:SetScript("OnEvent", function(_, _)
                    UpdateVisibility(GetActionBarPage(), FadeIn, FadeOut)
                end)
                FadeBlizzardBars.PageWatchers[barData.key] = pageWatcher
            end

            bar:HookScript("OnEnter", FadeIn)
            bar:HookScript("OnLeave", FadeOut)

            for _, buttonKey in ipairs(barData.buttons) do
                local btn = _G[buttonKey]
                if btn then
                    btn:HookScript("OnEnter", FadeIn)
                    btn:HookScript("OnLeave", FadeOut)
                end
            end
        elseif bar then
            bar:SetAlpha(1)
        end
    end
end