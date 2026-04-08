local _, FadeBlizzardBars = ...
local _G = _G

function FadeBlizzardBars:HandleClickThroughBars(optionKey)
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

    for key, option in pairs(options) do
        local barData = self.Utilities.GetBarFromCollection(key)
        local bar = _G[barData.frame]
        if bar then
            for _, buttonKey in ipairs(barData.buttons) do
                local btn = _G[buttonKey]
                if btn then
                    btn:EnableMouse(option.clickThrough == false)
                end
            end
        end
    end
end