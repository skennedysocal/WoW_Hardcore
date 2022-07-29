local _G = _G
local beserker_achievement = CreateFrame("Frame")
_G.achievements.Beserker = beserker_achievement

-- General info
beserker_achievement.name = "Beserker"
beserker_achievement.title = "Beserker"
beserker_achievement.class = "Warrior"
beserker_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_default.blp"
beserker_achievement.description = "Complete the Hardcore challenge without at any point equipping Mail or Plate armor or a Shield. Only cloth and leather armor are allowed. If your race starts with a Shield, unequip it upon logging in."

-- Registers
function beserker_achievement:Register(fail_function_executor)
	beserker_achievement.fail_function_executor = fail_function_executor 
end

function beserker_achievement:Unregister()
	beserker_achievement.fail_function_executor = nil 
end

-- Register Definitions
beserker_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
end)
