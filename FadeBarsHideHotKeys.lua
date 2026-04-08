local _, FadeBlizzardBars = ...;
local _G = _G

local function ToggleOption(obj, hide)
    if hide == true then
        obj:Hide()
    else
        obj:Show()
    end
end

function FadeBlizzardBars:HideHotKeys(optionKey)
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

    C_Timer.After(0, function()
        for key, option in pairs(options) do
            local buttons = self.Utilities.GetBarFromCollection(key).buttons
            for _, buttonKey in pairs(buttons) do
                local btn = _G[buttonKey]
                if btn then
                    local hotkey = btn.HotKey
                    if hotkey then
                        ToggleOption(hotkey, option.hideHotKeys == true)
                    end
                    local macroName = btn.Name
                    if macroName then
                        ToggleOption(macroName, option.hideMacrosNames == true)
                    end
                end
            end
        end
    end)
end
