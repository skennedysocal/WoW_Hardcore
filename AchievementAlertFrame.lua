achievement_alert_handler = {}

-- Animated border
-- local test_frame = CreateFrame("Frame");
-- test_frame:SetSize(400, 400)
-- test_frame:SetHeight(200)
-- test_frame:SetWidth(400)
-- test_frame:SetPoint("CENTER", UIParent, 0, 0)
-- local tex = test_frame:CreateTexture()
-- tex:SetHeight(200)
-- tex:SetWidth(400)
-- tex:SetTexture("Interface\\Addons\\Hardcore\\Media\\test_sprite.blp")
-- tex:SetHeight(200)
-- tex:SetWidth(400)
-- tex:SetSize(400,400)
-- tex:SetDrawLayer("OVERLAY", 7)
-- tex:SetAllPoints()
-- tex:SetParent(UIParent)

-- test_frame:Show()
-- tex:Show()
-- _G.HCTextureUtils:AddToAnimationFrames("TestFrame", tex, _G.HCTextureInfo.TestFrame.test_sprite.AnimationInfo)

-- test_frame:HookScript("OnUpdate", function(self, elapsed)
-- _G.HCTextureUtils.Animate_OnUpdate(elapsed)
-- end)

-- C_Timer.After(5.0, function()
-- 	test_frame:Hide()
-- 	tex:Hide()
-- end)


local static_offset_x = 0
local static_offset_y = 250
local modified_offset_x = 0
local modified_offset_y = 0

local achievement_alert_frame = CreateFrame("frame")
achievement_alert_frame:SetHeight(200)
achievement_alert_frame:SetWidth(400)
achievement_alert_frame:SetPoint("CENTER", UIParent, static_offset_x + modified_offset_x, static_offset_y + modified_offset_y)
local t = achievement_alert_frame:CreateTexture()
local text = achievement_alert_frame:CreateFontString(nil,"OVERLAY") 
text:SetFont("Interface\\AddOns\\Hardcore\\Media\\BreatheFire.ttf", 26)
text:SetTextColor(.98, .86, 0, 1)
text:SetPoint("CENTER",0, -55)
text:SetText("long long long long long long long long long long.")
text:SetWidth(350)

local achievement_alert_frame_icon = CreateFrame("frame")
achievement_alert_frame_icon:SetHeight(105)
achievement_alert_frame_icon:SetWidth(105)
achievement_alert_frame_icon:SetPoint("CENTER", achievement_alert_frame, 0, 16)

local t2 = achievement_alert_frame_icon:CreateTexture()

t:SetAllPoints()
t:SetTexture("Interface\\Addons\\Hardcore\\Media\\alert_border_alpha.blp")
t:SetSize(1000,1000)
t:SetDrawLayer("OVERLAY", 7)
t:SetParent(UIParent)
achievement_alert_frame:Hide()
t:Hide()

t2:SetAllPoints()
t2:SetTexture("Interface\\Addons\\Hardcore\\Media\\icon_absent_minded_prospector.blp")
t2:SetSize(1000,1000)
t2:SetDrawLayer("OVERLAY", 6)
t2:SetParent(UIParent)
achievement_alert_frame_icon:Hide()

function achievement_alert_handler:Hide()
  t:Hide()
  t2:Hide()
  achievement_alert_frame:Hide()
  achievement_alert_frame_icon:Hide()
end

function achievement_alert_handler:Show()
  t:Show()
  t2:Show()
  achievement_alert_frame:Show()
  achievement_alert_frame_icon:Show()
end

function achievement_alert_handler:ShowTimed(_time)
	achievement_alert_handler:Show()
	C_Timer.After(_time or 1.0, function()
		achievement_alert_handler:Hide()
	end)
end

function achievement_alert_handler:SetIcon(_icon_path)
      t2:SetTexture(_icon_path)
end

function achievement_alert_handler:SetMsg(_msg)
      text:SetText(_msg)
end

function achievement_alert_handler:SetScale(_scale)
	achievement_alert_frame:SetHeight(200*_scale)
	achievement_alert_frame:SetWidth(400*_scale)
	achievement_alert_frame_icon:SetHeight(105*_scale)
	achievement_alert_frame_icon:SetWidth(105*_scale)
	achievement_alert_frame_icon:SetPoint("CENTER", achievement_alert_frame, 0, 16*_scale)
end

function achievement_alert_handler:ApplySettings(_x_offset, _y_offset, _scale)
	modified_offset_x = _x_offset
	modified_offset_y = _y_offset
	achievement_alert_handler:SetScale(_scale)
	achievement_alert_frame:SetPoint("CENTER", UIParent, static_offset_x + modified_offset_x, static_offset_y + modified_offset_y)
end


achievement_alert_handler:SetScale(1.0)
achievement_alert_handler:Hide()
-- achievement_alert_handler:ShowTimed(5.0)
