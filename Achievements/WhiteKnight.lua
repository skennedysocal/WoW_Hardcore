local _G = _G
local white_knight_achievement = CreateFrame("Frame")
_G.achievements.WhiteKnight = white_knight_achievement

-- General info
white_knight_achievement.name = "WhiteKnight"
white_knight_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_white_knight.blp"
white_knight_achievement.description = "Complete the Hardcore challenge without at any point equipping an item that is of Green, Blue, or Purple quality. Only White and Gray items are allowed. Bags are equipped items."

-- Registers
function white_knight_achievement:Register(fail_function_executor)
	white_knight_achievement.fail_function_executor = fail_function_executor 
end

function white_knight_achievement:Unregister()
	white_knight_achievement.fail_function_executor = nil 
end

-- Register Definitions
white_knight_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
end)
