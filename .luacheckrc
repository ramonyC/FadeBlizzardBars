std = "lua51"
max_line_length = false
exclude_files = {
	"libs/",
	"locale/find-locale-strings.lua",
	".luacheckrc"
}

ignore = {
    "_G",
    "SLASH_FBB1",
    "SlashCmdList",
    "FadeBlizzardBarsDB",
}

globals = {
    "_G",
    "LibStub",
    "CreateFrame",
    "UIFrameFadeIn",
    "UIFrameFadeOut",
    "C_Timer",
    "ReloadUI",
    "GetActionBarPage",
}
