local _, FadeBlizzardBars = ...
local _G = _G

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

function FadeBlizzardBars:RestoreBlizzardDefaults(isEnabled)
    if isEnabled == true or self.Utilities.AddonEnabled() == true then
        return
    end

    for _, barData in ipairs(self.ActionBarCollection) do
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

function FadeBlizzardBars:DisableAddon()
    self.db.profile.enabled = false
    self:RestoreBlizzardDefaults(false)
end

function FadeBlizzardBars:ApplyFade(optionKey)
    if self.Utilities.AddonEnabled() then
        self:HandleFadeBars(optionKey)
    end
end

function FadeBlizzardBars:ApplyClickThrough(optionKey)
    if self.Utilities.AddonEnabled() then
        self:HandleClickThroughBars(optionKey)
    end
end

function FadeBlizzardBars:EnableAddon()
    self.Utilities.SetAddonEnabled(true)
    self:ApplyClickThrough()
    self:ApplyFade()
end