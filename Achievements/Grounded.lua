local _G = _G
local grounded_achievement = CreateFrame("Frame")
_G.achievements.Grounded = grounded_achievement

-- General info
grounded_achievement.name = "Grounded"
grounded_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_grounded.blp"
grounded_achievement.description = "Complete the Hardcore challenge without at any point using a mount, flight path, or portal. Zeppelins and ships can be used."

-- Registers
function grounded_achievement:Register(fail_function_executor)
	grounded_achievement.fail_function_executor = fail_function_executor 
end

function grounded_achievement:Unregister()
	grounded_achievement.fail_function_executor = nil 
end

-- Register Definitions
grounded_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
end)
