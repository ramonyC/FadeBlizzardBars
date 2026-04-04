local _, FadeBlizzardBars = ...

FadeBlizzardBars.HandleClickThrough = function(_G)
    for _, barData in ipairs(FadeBlizzardBars.ClickThruBars) do
        local bar = _G[barData.frame]
        if bar then
            bar:EnableMouse(false)
            for i = 1, 12 do
                local btn = _G[barData.buttons .. i]
                if btn then btn:EnableMouse(false) end
            end
        end
    end
end