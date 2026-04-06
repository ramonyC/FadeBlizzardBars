local _, FadeBlizzardBars = ...

FadeBlizzardBars.GetBarByKey = function(key)
    for _, bar in ipairs(FadeBlizzardBars.ActionBarCollection) do
        if bar.key == key then
            return bar
        end
    end
end

FadeBlizzardBars.IsEnabled = function()
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return false
    end

    return userProfile.enabled;
end

FadeBlizzardBars.SetIsEnabled = function(value)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    userProfile.enabled = value;
end

FadeBlizzardBars.GetBarOption = function(barKey, optionKey)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return nil
    end

    local barOptions = userProfile.barOptions[barKey]
    if not barOptions then
        return nil
    end

    return barOptions[optionKey]
end

FadeBlizzardBars.SetBarOption = function(barKey, optionKey, value)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    if not barKey or not optionKey then
        return
    end

    userProfile.barOptions[barKey][optionKey] = value
end

FadeBlizzardBars.SetBarAdditionalOption = function(barKey, optionKey, additionalOptionKey, value)
    local userProfile = FadeBlizzardBars.db and FadeBlizzardBars.db.profile or nil
    if not userProfile then
        return
    end

    if not barKey or not optionKey or not additionalOptionKey then
        return
    end

    userProfile.barOptions[barKey][optionKey][additionalOptionKey] = value
end
