local _, FadeBlizzardBars = ...

FadeBlizzardBars.FadeConstants = {
    FADE_IN_TIME = 0.2,
    FADE_OUT_TIME = 0.2,
    FADE_OUT_DELAY = 0.2,
}

FadeBlizzardBars.ClickThruBars = {
    { frame = "MultiBar6",    buttons = "MultiBar6Button"       }, -- Bar 7
    { frame = "MultiBar7",    buttons = "MultiBar7Button"       }, -- Bar 8
}

FadeBlizzardBars.HoverBars = {
    { frame = "MainActionBar",   buttons = "ActionButton" }, -- Main Action Bar
    { frame = "MultiBarBottomLeft", buttons = "MultiBarBottomLeftButton" }, -- Bar 2
    { frame = "MultiBarBottomRight", buttons = "MultiBarBottomRightButton" }, -- Bar 3
    { frame = "MultiBarRight", buttons = "MultiBarRightButton" }, -- Bar 4
    { frame = "MultiBarLeft", buttons = "MultiBarLeftButton" }, -- Bar 5
    { frame = "MultiBar5", buttons = "MultiBar5Button" }, -- Bar 6
    { frame = "PetActionBar", buttons = "PetActionButton" }, -- Pet Action Bar
    { frame = "StanceBar", buttons = "StanceButton" }, -- Stance Bar
}

FadeBlizzardBars.UniqueHoverBars = {
    { frame = "BagsBar", buttons = {
        "CharacterBag0Slot", "CharacterBag1Slot", "CharacterBag2Slot", "CharacterBag3Slot",
        "MainMenuBarBackpackButton", "CharacterReagentBag0Slot", "CharacterReagentBag1Slot", "CharacterReagentBag2Slot", "CharacterReagentBag3Slot"
    } }, -- Bags Bar
    { frame = "MicroMenuContainer", buttons = {
        "CharacterMicroButton", "SpellbookMicroButton", "TalentMicroButton", "AchievementMicroButton",
        "QuestLogMicroButton", "GuildMicroButton", "ProfessionMicroButton", "PlayerSpellsMicroButton", "HousingMicroButton", "LFDMicroButton",
        "CollectionsMicroButton", "EJMicroButton", "StoreMicroButton", "MainMenuMicroButton"
    } }, -- Micro Menu Bar
}
