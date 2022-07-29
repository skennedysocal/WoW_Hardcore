local _G = _G
local homebound_achievement = CreateFrame("Frame")
_G.achievements.Homebound = homebound_achievement

-- General info
homebound_achievement.name = "Homebound"
homebound_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_homebound.blp"
homebound_achievement.description = "Complete the Hardcore challenge without at any point leaving the continent on which your character has started. If you started in Kalimdor, you may at no point enter the Eastern Kingdoms. If you started in the Eastern Kingdoms, you may at no point enter Kalimdor."

-- Registers
function homebound_achievement:Register(fail_function_executor)
	homebound_achievement.fail_function_executor = fail_function_executor 
end

function homebound_achievement:Unregister()
	homebound_achievement.fail_function_executor = nil 
end

-- Register Definitions
homebound_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
end)
