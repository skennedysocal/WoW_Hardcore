local _G = _G
local self_made_achievement = CreateFrame("Frame")
_G.achievements.SelfMade = self_made_achievement

-- General info
self_made_achievement.name = "SelfMade"
self_made_achievement.title = "Self-Made"
self_made_achievement.class = "All"
self_made_achievement.icon_path = "Interface\\Addons\\Hardcore\\Media\\icon_self_made.blp"
self_made_achievement.description =
"Complete the Hardcore challenge without at any point equipping an item that you have not crafted yourself (Fishing Poles are acceptable). Items your character has conjured (e.g. Firestones) are considered crafted. No items bought, dropped, or rewarded by quests are allowed to be equipped (items provided for a quest can be equipped). The items your character starts with are allowed to be equipped. Bags are equipped items."

-- Registers
function self_made_achievement:Register(fail_function_executor)
	self_made_achievement:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self_made_achievement.fail_function_executor = fail_function_executor
end

function self_made_achievement:Unregister()
	self_made_achievement:UnregisterEvent("PLAYER_EQUIPMENT_CHANGED")
end

-- This function loops through a given tooltip when the "PLAYER_EQUIPMENT_CHANGED" event fires.
-- If it finds the player's name in the tooltip it sets the varible to true and you do not fail the achievement,
-- If false then the rest of the event fires, failing the player.

local function isSelfCreated(...)
	local player_found = false
	for i = 1, GameTooltip:NumLines() do
		local player = UnitName("player")
		local mytextLeft = _G["GameTooltipTextLeft" .. i]
		local textL = mytextLeft:GetText()
		if string.match(textL, player) then
			player_found = true
			break
		else
			player_found = false
		end
	end
	return player_found
end

-- Register Definitions

-- This executes on player equipping and item, then calls isSelfCreated()
-- To check the tooltip for the player's name.
self_made_achievement:SetScript("OnEvent", function(self, event, ...)
	local arg = { ... }
	local player = UnitName("player")
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		if arg[2] == true then
			return
		end
		local item_id = GetInventoryItemID("player", arg[1])
		local item_name, _, _, _, _, item_type, item_subtype, _, _, _, _ = GetItemInfo(item_id)
		-- Checks if the tooltip had a match with the player name, if it returned false, this will execute.
		if isSelfCreated() == false then
			-- Since it returned false, we check if they are equipping a fishing pole, if it is do nothing.
			-- Otherwise fail them.
			if item_subtype ~= "Fishing Poles" then
				Hardcore:Print("Equipped " .. item_name .. " which was not created by " .. player)
				self_made_achievement.fail_function_executor.Fail(self_made_achievement.name)
			end
		end
	end
end)
