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
            bar:SetScale(1)
            bar:EnableMouse(true)
            for _, buttonKey in ipairs(barData.buttons) do
                local btn = _G[buttonKey]
                if btn then
                    btn:EnableMouse(true)

                    local hotkey = btn.HotKey
                    if hotkey and hotkey:GetText() ~= ""
                        and hotkey:GetText() ~= RANGE_INDICATOR then
                        hotkey:Show()
                    end

                    local macroName = btn.Name
                    if macroName then
                        macroName:Show()
                    end
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

function FadeBlizzardBars:ApplyScale(optionKey, withDelay)
    C_Timer.After(withDelay or 0, function()
        if self.Utilities.AddonEnabled() and not InCombatLockdown() then
            self:HandleScaleBars(optionKey)
        else
            -- Workaround to scale bar if user /reload while in combat
            self:ApplyScale(optionKey, 1)
        end
    end)
end

function FadeBlizzardBars:ApplyHideHotKeys(optionKey)
    if self.Utilities.AddonEnabled() then
        self:HideHotKeys(optionKey)
    end
end

function FadeBlizzardBars:ApplyShowOnMount()
    if not self.Utilities.AddonEnabled() then
        return
    end

    if IsMounted() == true then
        for _, barData in ipairs(self.ActionBarCollection) do
            if self.Utilities.GetDBBarOption(barData.key, "showOnMount") == true then
                local bar = _G[barData.frame]
                if bar then
                    bar:SetAlpha(1)
                end
            end
        end
    else
        for _, barData in ipairs(self.ActionBarCollection) do
            if self.Utilities.GetDBBarOption(barData.key, "showOnMount") == true then
                self:ApplyFade(barData.key)
            end
        end
    end
end

function FadeBlizzardBars:EnableAddon()
    self.Utilities.SetAddonEnabled(true)
    self:ApplyClickThrough()
    self:ApplyFade()
    self:ApplyScale()
    self:ApplyHideHotKeys()
end