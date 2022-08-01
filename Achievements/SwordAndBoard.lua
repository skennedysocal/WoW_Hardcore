local _G = _G
local sword_and_board_achievement = CreateFrame("Frame")
_G.achievements.SwordAndBoard = sword_and_board_achievement

-- General info
sword_and_board_achievement.name = "SwordAndBoard"
sword_and_board_achievement.title = "Sword & Board"
sword_and_board_achievement.class = "Warrior"
sword_and_board_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_default.blp"
sword_and_board_achievement.description = "Complete the Hardcore challenge without at any point equipping Mail or Plate armor or a Shield. Only cloth and leather armor are allowed. If your race starts with a Shield, unequip it upon logging in."

-- Registers
function sword_and_board_achievement:Register(fail_function_executor)
	sword_and_board_achievement:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	sword_and_board_achievement:RegisterEvent("PLAYER_LEVEL_UP")
	sword_and_board_achievement.fail_function_executor = fail_function_executor 
end

function sword_and_board_achievement:Unregister()
	sword_and_board_achievement:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
	sword_and_board_achievement:UnregisterEvent("PLAYER_LEVEL_UP")
	sword_and_board_achievement.fail_function_executor = nil 
end

-- Register Definitions
sword_and_board_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = {...}
	if (event == "PLAYER_EQUIPMENT_CHANGED") then
	    if (arg[2] == true) then
	      return
	    end
	    local item_id = GetInventoryItemID("player", arg[1])
	    local item_name, _, _, _, _, item_type, item_subtype, _, _, _, _ = GetItemInfo(item_id)
	    if (arg[1] == 16) then -- Mainhand
	      if item_type == "Weapon" then
		if item_subtype == "Two-Handed Axes" or item_subtype == "Two-Handed Maces" or item_subtype == "Two-Handed Swords" or item_subtype == "Polearms" or item_subtype == "Staves" or item_subtype == "Fishing Poles" then
		  Hardcore:Print("Equiped " .. item_name .. ".")
		  sword_and_board_achievement.fail_function_executor.Fail(sword_and_board_achievement.name)
		end
	      end
	    elseif (arg[1] == 17) then -- Offhand
	      if item_type == "Weapon" then
		Hardcore:Print("Equiped " .. item_name .. ".")
		sword_and_board_achievement.fail_function_executor.Fail(sword_and_board_achievement.name)
	      end
	    end
	end
end)
