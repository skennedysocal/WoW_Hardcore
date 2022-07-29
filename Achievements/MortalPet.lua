local _G = _G
local mortal_pet_achievement = CreateFrame("Frame")
_G.achievements.MortalPet = mortal_pet_achievement

-- General info
mortal_pet_achievement.name = "MortalPet"
mortal_pet_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_default.blp"
mortal_pet_achievement.description = "Complete the Hardcore challenge without at any point resurrecting your pet. If your pet dies for any reason, you have to release it and tame another one."

-- Registers
function mortal_pet_achievement:Register(fail_function_executor)
	mortal_pet_achievement.fail_function_executor = fail_function_executor 
end

function mortal_pet_achievement:Unregister()
	mortal_pet_achievement.fail_function_executor = nil 
end

-- Register Definitions
mortal_pet_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
end)
