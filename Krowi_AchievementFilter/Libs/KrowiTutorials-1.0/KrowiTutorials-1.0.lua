--- KrowiTutorials-1.0
--- Tutorials from Krowi based on MSA-Tutorials-1.0 from Marouan Sabbagh

--- MSA-Tutorials-1.0
--- Tutorials from Marouan Sabbagh based on CustomTutorials from João Cardoso.

--[[
Copyright 2010-2015 João Cardoso
CustomTutorials is distributed under the terms of the GNU General Public License (or the Lesser GPL).

CustomTutorials is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CustomTutorials is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with CustomTutorials. If not, see <http://www.gnu.org/licenses/>.
--]]

--[[
General Arguments
-----------------
 savedvariable
 icon ........... Default is "?" icon. Image path (tga or blp).
 title .......... Default is "Tutorial".
 width .......... Default is 512 + 20. Internal frame width (without borders). Allows for 512 wide images to have some space between image and borders.
 font ........... Default is game font (empty string).

Frame Arguments
---------------
 title .......... Title relative to frame (replace General value).
 width .......... Width relative to frame (replace General value).
Note: All other arguments can be used as a general!
 image .......... [optional] Image path (tga or blp).
 imageHeight .... Default is 128. Default image size is 256x128.
 imageX ......... Default is 0 (center). Left/Right position relative to center.
 imageY ......... Default is 20 (top margin).
 text ........... Text string.
 textHeight ..... Default is 0 (auto height).
 textX .......... Default is 25. Left and Right margin.
 textY .......... Default is 20 (top margin).
 editbox ........ [optional] Edit box text string (directing value). Edit box is out of content flow.
 editboxWidth ... Default is 400.
 editboxLeft, editboxBottom
 button ......... [optional] Button text string (directing value). Button is out of content flow.
 buttonWidth .... Default is 100.
 buttonClick .... Function with button's click action.
 buttonLeft, buttonBottom
 shine .......... [optional] The frame to anchor the flashing "look at me!" glow.
 shineAll ....... [optional] Set shineTop, shineBottom, shineLeft, shineRight to the same value, can be overwritten by the invidual arguments or shineWidth and shineHeight
 shineWidth ..... [optional] Set shineLeft, shineRight to the same value, can be overwritten by the invidual arguments
 shineHeight .... [optional] Set shineTop, shineBottom to the same value, can be overwritten by the invidual arguments
 shineTop, shineBottom, shineLeft, shineRight
 point .......... Default is "CENTER".
 anchor ......... Default is "UIParent".
 relPoint ....... Default is "CENTER".
 x, y ........... Default is 0, 0.
--]]

-- Lua API
local floor = math.floor
local fmod = math.fmod
local format = string.format
local strfind = string.find
local round = function(n) return floor(n + 0.5) end

local lib = LibStub:NewLibrary('KrowiTutorials-1.0', 1)
if lib then
	lib.NewFrame, lib.NewButton, lib.UpdateFrame = nil, nil, nil
	lib.numFrames = lib.numFrames or 1
	lib.frames = lib.frames or {}
else
	return
end

local BUTTON_TEX = 'Interface\\Buttons\\UI-SpellbookIcon-%sPage-%s'
local Frames = lib.frames

local default = {
	title = "Tutorial",
	width = 512 + 20,
	font = "",
	imageHeight = 128,
	imageX = 0,
	imageY = 20,
	textHeight = 0,
	textX = 25,
	textY = 20,
	editboxWidth = 400,
	buttonWidth = 100,
	point = "CENTER",
	anchor = UIParent,
	relPoint = "CENTER",
	x = 0,
	y = 0,
}

--[[ Internal API ]]--

local function UpdateFrame(frame, i)
	local data = frame.data[i]
	if not data then
		return
	end

	if not data.image and not data.textY then
		data.textY = 0
	end
	for k, v in pairs(default) do
		if not data[k] then
			if not frame.data[k] then
				data[k] = v
			else
				data[k] = frame.data[k]
			end
		end
	end
	
	-- Callbacks
	if frame.data.onShow then
		frame.data.onShow(frame.data, i)
	end
	if frame.data.onHide then
		frame.data.onHide()
	end

	-- Frame
	frame:ClearAllPoints()
	frame:SetPoint(data.point, data.anchor, data.relPoint, data.x, data.y)
	frame:SetWidth(data.width + 16)
	frame.TitleText:SetPoint('TOP', 0, -5)
	frame.TitleText:SetText(data.title)
	
	-- Cache inline texture
	local j, idx = 1, 1
	local lastTex
	while idx do
		local s, e, tex = strfind(data.text, "|T(Interface\\AddOns\\[^:]+)[^|]+|t", idx)
		if tex then
			if tex ~= lastTex then
				if not frame["cache"..j] then
					frame["cache"..j] = frame:CreateTexture()
				end
				frame["cache"..j]:SetTexture(tex)
				lastTex = tex
				j = j + 1
			end
			idx = e
		else
			break
		end
	end
	
	-- Image
	for _, image in pairs(frame.images) do
		image:Hide()
	end
	if data.image then
		local img = frame.images[i] or frame:CreateTexture()
		img:SetPoint('TOP', frame, data.imageX - 1, -(26 + data.imageY))
		img:SetTexture(data.image)
		img:Show()
		frame.images[i] = img
	end
	
	-- Text
	if data.subTitle then
		data.text = data.subTitle .. "\n\n" .. data.text;
	end
	frame.text:SetPoint('TOP', frame, 0, -((data.image and 26 + data.imageY + data.imageHeight or 60) + data.textY))
	frame.text:SetWidth(data.width - (2 * data.textX))
	frame.text:SetText(data.text)
	
	local textHeight = round(frame.text:GetHeight())
	if data.textHeight > textHeight then
		textHeight = data.textHeight
	end 
	textHeight = textHeight - fmod(textHeight, 2)
	frame:SetHeight((data.image and 56 + data.imageY + data.imageHeight or 90) + (data.text and data.textY + textHeight or 0) + 18)
	frame.i = i
	frame:Show()

	-- EditBox
	if data.editbox then
		frame.editbox:ClearFocus()
		frame.editbox:SetWidth(data.editboxWidth)
		frame.editbox:SetPoint('BOTTOMLEFT', 14 + data.textX + (data.editboxLeft or 0), 28 + 18 + (data.editboxBottom or 0))
		frame.editbox:SetText(data.editbox)
		frame.editbox:Show()
	else
		frame.editbox:Hide()
	end

	-- Button
	if data.button then
		frame.button:SetWidth(data.buttonWidth)
		frame.button:SetPoint('BOTTOMLEFT', 8 + data.textX + (data.buttonLeft or 0), 28 + 18 + (data.buttonBottom or 0))
		frame.button:SetText(data.button)
		frame.button:SetScript('OnClick', data.buttonClick)
		frame.button:Show()
	else
		frame.button:Hide()
	end

	-- Shine
	if data.shine then
		frame.shine:SetParent(data.shine)
		local shineTop, shineBottom, shineLeft, shineRight = 0, 0, 0, 0;

		data.shineAll = type(data.shineAll) == "function" and data.shineAll() or data.shineAll;
		if data.shineAll then
			shineTop = data.shineAll;
			shineBottom = -data.shineAll;
			shineLeft = -data.shineAll;
			shineRight = data.shineAll;
		end

		data.shineHeight = type(data.shineHeight) == "function" and data.shineHeight() or data.shineHeight;
		if data.shineHeight then
			shineTop = data.shineHeight;
			shineBottom = -data.shineHeight;
		end

		data.shineWidth = type(data.shineWidth) == "function" and data.shineWidth() or data.shineWidth;
		if data.shineWidth then
			shineLeft = -data.shineWidth;
			shineRight = data.shineWidth;
		end

		data.shineTop = type(data.shineTop) == "function" and data.shineTop() or data.shineTop;
		if data.shineTop then
			shineTop = data.shineTop;
		end

		data.shineBottom = type(data.shineBottom) == "function" and data.shineBottom() or data.shineBottom;
		if data.shineBottom then
			shineBottom = data.shineBottom;
		end

		data.shineLeft = type(data.shineLeft) == "function" and data.shineLeft() or data.shineLeft;
		if data.shineLeft then
			shineLeft = data.shineLeft;
		end

		data.shineRight = type(data.shineRight) == "function" and data.shineRight() or data.shineRight;
		if data.shineRight then
			shineRight = data.shineRight;
		end

		-- print(shineRight)
		-- print(shineLeft)
		-- print(shineTop)
		-- print(shineBottom)

		frame.shine:SetPoint('BOTTOMRIGHT', shineRight, shineBottom)
		frame.shine:SetPoint('TOPLEFT', shineLeft, shineTop)
		frame.shine:Show()
		frame.flash:Play()
	else
		frame.flash:Stop()
		frame.shine:Hide()
	end

	-- Buttons
	if i == 1 then
		frame.prev:Disable()
	else
		frame.prev:Enable()
	end
	frame.pageNum:SetText(("%d/%d"):format(i, frame.unlocked))
	if i < (frame.unlocked or 0) then
		frame.next:Enable()
	else
		frame.next:Disable()
	end

	-- Save
	local sv = frame.data.key or frame.data.savedvariable
	if sv then
		local table = frame.data.key and frame.data.savedvariable or _G
		table[sv] = max(i, table[sv] or 0)
	end
end

local function NewButton(frame, name, direction)
	local button = CreateFrame('Button', nil, frame)
	button:SetHighlightTexture('Interface\\Buttons\\UI-Common-MouseHilight')
	button:SetDisabledTexture(BUTTON_TEX:format(name, 'Disabled'))
	button:SetPushedTexture(BUTTON_TEX:format(name, 'Down'))
	button:SetNormalTexture(BUTTON_TEX:format(name, 'Up'))
	button:SetPoint('BOTTOM'..((direction == -1) and 'LEFT' or 'RIGHT'), -(30 * direction), 2)
	button:SetSize(26, 26)
	button:SetScript('OnClick', function()
		UpdateFrame(frame, frame.i + direction)
	end)

	local text = button:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	text:SetText(_G[strupper(name)])
	text:SetPoint('LEFT', -(13 + text:GetStringWidth()/2) * direction, 0)

	return button
end

local function FrameOnHide(self)
	self.flash:Stop()
	self.shine:Hide()
end

local function NewFrame(data)
	local frame = CreateFrame('Frame', 'Tutorials'..lib.numFrames, UIParent, 'ButtonFrameTemplate')
	frame.portrait:SetPoint('TOPLEFT', data.icon and -4 or -3, data.icon and 6 or 5)
	frame.portrait:SetTexture(data.icon or 'Interface\\TutorialFrame\\UI-HELP-PORTRAIT')
	frame.Inset:SetPoint('TOPLEFT', 4, -23)
	frame.Inset.Bg:SetColorTexture(0, 0, 0)

	frame.images = {}
	frame.text = frame:CreateFontString(nil, nil, 'GameFontHighlight')
	if data.font then
		frame.text:SetFont(data.font, 12)
	end
	frame.text:SetJustifyH('LEFT')

	frame.prev = NewButton(frame, 'Prev', -1)
	frame.next = NewButton(frame, 'Next', 1)

	frame.pageNum = frame:CreateFontString(nil, nil, 'GameFontHighlightSmall')
	frame.pageNum:SetPoint('BOTTOM', 0, 10)

	frame:SetFrameStrata('DIALOG')
	frame:SetClampedToScreen(true)
	frame:EnableMouse(true)
	frame:SetToplevel(true)
	frame:SetScript('OnHide', FrameOnHide);

	frame.editbox = CreateFrame('EditBox', nil, frame, 'InputBoxTemplate')
	frame.editbox:SetHeight(20)
	frame.editbox:SetAutoFocus(false)
	frame.editbox:Hide()

	frame.button = CreateFrame('Button', nil, frame, 'UIPanelButtonTemplate')
	frame.button:SetSize(100, 22)
	frame.button:SetPoint("CENTER")
	frame.button:Hide()

	frame.shine = CreateFrame('Frame', nil, frame, 'BackdropTemplate')
	frame.shine:SetBackdrop({edgeFile = 'Interface\\TutorialFrame\\UI-TutorialFrame-CalloutGlow', edgeSize = 16})
	for i = 1, frame.shine:GetNumRegions() do
		select(i, frame.shine:GetRegions()):SetBlendMode('ADD')
	end

	local flash = frame.shine:CreateAnimationGroup()
	flash:SetLooping('BOUNCE')
	frame.flash = flash
	
	local anim = flash:CreateAnimation('Alpha')
	anim:SetDuration(.75)
	anim:SetFromAlpha(.7)
	anim:SetToAlpha(0)

	frame.data = data
	lib.numFrames = lib.numFrames + 1
	return frame
end

local function ApplyElvUISkin(frame)
    if ElvUI == nil then
		return;
	end

    local engine = unpack(ElvUI);
    local blizzardSkins = engine.private.skins.blizzard;
    local tutorials = blizzardSkins.enable and blizzardSkins.tutorials;

	if not tutorials then
		return;
	end

    local skins = engine:GetModule("Skins");

	frame:StripTextures();
	frame:CreateBackdrop('Transparent');

	skins:HandleCloseButton(frame.CloseButton);
	skins:HandleNextPrevButton(frame.prev, 'left');
	skins:HandleNextPrevButton(frame.next, 'right');

end

--[[ User API ]]--

function lib:RegisterTutorial(data)
	assert(type(data) == 'table', 'RegisterTutorials: 2nd arg must be a table', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	if not lib.frames[self] then
		lib.frames[self] = NewFrame(data)
		ApplyElvUISkin(lib.frames[self]);
	end
end

function lib:TriggerTutorial(index, maxAdvance)
	assert(type(index) == 'number', 'TriggerTutorial: 2nd arg must be a number', 2)
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		local table = frame.data.key and frame.data.savedvariable or _G
		local last = sv and table[sv] or 0
		
		if index > last then
			frame.unlocked = index
			UpdateFrame(frame, (maxAdvance == true or not sv) and index or last + (maxAdvance or 1))
		end
	end
end

function lib:ShowPage(index, maxAdvance)
	self:ResetTutorial();
	self:TriggerTutorial(index, maxAdvance);
end

function lib:ResetTutorial()
	assert(self, 'RegisterTutorials: 1st arg was not provided', 2)

	local frame = lib.frames[self]
	if frame then
		local sv = frame.data.key or frame.data.savedvariable
		if sv then
			local table = frame.data.key and frame.data.savedvariable or _G
			table[sv] = false
		end
		
		frame:Hide()
	end
end

function lib:GetTutorial()
	return self and lib.frames[self] and lib.frames[self].data
end

function lib:IsTutorialOpen()
	return lib.frames[self]:IsShown();
end

function lib:CloseButtonHook(func)
	if lib.frames[self] then
		lib.frames[self]:SetScript("OnHide", function(self)
			FrameOnHide(self);
			func();
		end);
	end
end