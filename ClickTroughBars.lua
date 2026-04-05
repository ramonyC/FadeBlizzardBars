local _, FadeBlizzardBars = ...
local _G = _G

FadeBlizzardBars.HandleClickThroughBars = function()
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    for key, option in pairs(userProfile.barOptions) do
        local barData = FadeBlizzardBars.GetBarByKey(key)
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