local _, FadeBlizzardBars = ...
local _G = _G

FadeBlizzardBars.ApplyFade = function()
    FadeBlizzardBars.HandleFadeBars()
end

FadeBlizzardBars.ApplyClickThrough = function()
    FadeBlizzardBars.HandleClickThroughBars()
end

local function UnregisterPageWatcher(barKey)
    if not barKey then
        return
     end

    local pageWatcher = FadeBlizzardBars.PageWatchers[barKey]
    if pageWatcher then
        pageWatcher:UnregisterAllEvents()
        pageWatcher:SetScript("OnEvent", nil)
        FadeBlizzardBars.PageWatchers[barKey] = nil
    end
end

FadeBlizzardBars.DisableAddon = function()
    FadeBlizzardBars.db.profile.enabled = false

    for _, barData in ipairs(FadeBlizzardBars.ActionBarCollection) do
        local bar = _G[barData.frame]
        if bar then
            bar:SetAlpha(1)
            bar:EnableMouse(true)
            for _, buttonKey in ipairs(barData.buttons) do
                local btn = _G[buttonKey]
                if btn then
                    btn:EnableMouse(true)
                end
            end
        end

        UnregisterPageWatcher(barData.key)
    end
end

FadeBlizzardBars.EnableAddon = function()
    FadeBlizzardBars.SetIsEnabled(true)
    FadeBlizzardBars:ApplyClickThrough()
    FadeBlizzardBars:ApplyFade()
end