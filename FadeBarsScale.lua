local _, FadeBlizzardBars = ...
local _G = _G

function FadeBlizzardBars:HandleScaleBars(optionKey)
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

    -- Required to apply setting on /reload or login
    C_Timer.After(0, function()
        for key, option in pairs(options) do
            local scaleSettings = option.scaleSettings
            local barData = self.Utilities.GetBarFromCollection(key)
            local bar = _G[barData.frame]
            if bar then
                if scaleSettings.enabled == true then
                    bar:SetScale(scaleSettings.scale or 1)
                else
                    bar:SetScale(1)
                end
            end
        end
    end)
end