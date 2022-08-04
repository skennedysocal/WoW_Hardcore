local _G = _G
local no_health_potions_achievement = CreateFrame("Frame")
_G.achievements.NoHealthPotions = no_health_potions_achievement

-- General info
no_health_potions_achievement.name = "NoHealthPotions"
no_health_potions_achievement.title = "No Health Potions"
no_health_potions_achievement.class = "All"
no_health_potions_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_no_health_potions.blp"
no_health_potions_achievement.description =
	"Complete the Hardcore challenge without at any point consuming a health potion (items with ‘Healing Potion’ in their name). Items that restore health which are not Healing Potions (e.g. Healthstones or Crystal Restore) can be used."

-- Registers
function no_health_potions_achievement:Register(fail_function_executor)
	no_health_potions_achievement:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	no_health_potions_achievement.fail_function_executor = fail_function_executor
end

function no_health_potions_achievement:Unregister()
	no_health_potions_achievement:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end

-- Register Definitions
no_health_potions_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local unit, _, spell_id, _, _ = ...
		if unit ~= "player" then
			return
		end
		local spell_name = GetSpellInfo(spell_id)
		if string.find(spell_name, "Healing Potion") ~= nil then
			Hardcore:Print("Casted healing potion spell." .. spell_name)
			no_health_potions_achievement.fail_function_executor.Fail(no_health_potions_achievement.name)
		end
	end
end)
