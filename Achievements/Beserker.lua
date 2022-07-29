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
	beserker_achievement:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	beserker_achievement:RegisterEvent("PLAYER_LEVEL_UP")
	beserker_achievement.fail_function_executor = fail_function_executor 
end

function beserker_achievement:Unregister()
	beserker_achievement:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	beserker_achievement:UnregisterEvent("PLAYER_LEVEL_UP")
	beserker_achievement.fail_function_executor = nil 
end

-- Register Definitions
beserker_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
	if (event == "PLAYER_EQUIPMENT_CHANGED") then
	    if (arg[2] == true) then
	      return
	    end
	    local item_id = GetInventoryItemID("player", arg[1])
	    local item_name, _, _, _, _, item_type, item_subtype, _, _, _, _ = GetItemInfo(item_id)
	    print(GetItemInfo(item_id) .. item_type .. item_subtype)
	    if item_type == "Armor" then
	      if item_subtype == "Shields" or item_subtype == "Mail" or item_subtype == "Plate" then
		Hardcore:Print("Equiped " .. item_name .. ".")
		beserker_achievement.fail_function_executor.Fail(beserker_achievement.name)
	      end
	    end
	elseif (event == "PLAYER_LEVEL_UP") then
	    for i=1,15 do
	      local item_id = GetInventoryItemID("player", i)
	      local item_name, _, _, _, _, item_type, item_subtype, _, _, _, _ = GetItemInfo(item_id)
	    if item_type == "Armor" then
	      if item_subtype == "Shields" or item_subtype == "Mail" or item_subtype == "Plate" then
		  Hardcore:Print("Equiped " .. item_name .. ".")
		  beserker_achievement.fail_function_executor.Fail(beserker_achievement.name)
		end
	      end
	    end
	end
end)
