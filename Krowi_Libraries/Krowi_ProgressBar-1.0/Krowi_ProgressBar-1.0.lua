--[[
	Krowi's Progress Bar License
		Copyright ©2020-2021 The contents of this library, excluding third-party resources, are
		copyrighted to their authors with all rights reserved.

		This library is free to use and the authors hereby grants you the following rights:

		1. 	You may make modifications to this library for private use only, you
			may not publicize any portion of this library. The only exception being you may
			upload to the github website.

		2. 	Do not modify the name of this library, including the library folders.

		3. 	This copyright notice shall be included in all copies or substantial
			portions of the Software.

		All rights not explicitly addressed in this license are reserved by
		the copyright holders.
]]

local lib = LibStub:NewLibrary("Krowi_ProgressBar-1.0", 1);

if not lib then
	return;
end

local borderLeftRightWidth, borderTopBottomHeight, borderLeftRightMiddleHeight;
local function Resize(self)
	local multiplier = self:GetWidth() / 224;
	self.BorderLeftTop:SetWidth(borderLeftRightWidth * multiplier);
	self.BorderLeftBottom:SetWidth(borderLeftRightWidth * multiplier);
	self.BorderLeftMiddle:SetWidth(borderLeftRightWidth * multiplier);
	self.BorderRightTop:SetWidth(borderLeftRightWidth * multiplier);
	self.BorderRightBottom:SetWidth(borderLeftRightWidth * multiplier);
	self.BorderRightMiddle:SetWidth(borderLeftRightWidth * multiplier);

	if self.CustomHeight then
		multiplier = self:GetHeight() / 25;
	end
	self:SetHeight(25 * multiplier, true);
	self.BorderLeftTop:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderLeftBottom:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderRightTop:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderRightBottom:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderMiddleTop:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderMiddleBottom:SetHeight(borderTopBottomHeight * multiplier);
	self.BorderLeftMiddle:SetHeight(borderLeftRightMiddleHeight * multiplier);
	self.BorderRightMiddle:SetHeight(borderLeftRightMiddleHeight * multiplier);

	local barWidth = self.BorderMiddleMiddle:GetWidth();
	for i, _ in next, self.Fill do
		local width = barWidth / (self.Max - self.Min) * self.Values[i];
		self.Fill[i]:SetWidth(width);
		self.Fill[i]:ClearAllPoints();
		if i == 1 then
			self.Fill[i]:SetPoint("TOPLEFT", self.BorderMiddleMiddle);
			self.Fill[i]:SetPoint("BOTTOMLEFT", self.BorderMiddleMiddle);
			if width == 0 then
				self.Fill[i]:SetPoint("RIGHT", self.BorderMiddleMiddle, "LEFT");
			end
		else
			self.Fill[i]:SetPoint("TOPLEFT", self.Fill[i - 1], "TOPRIGHT");
			self.Fill[i]:SetPoint("BOTTOMLEFT", self.Fill[i - 1], "BOTTOMRIGHT");
			if width == 0 then
				self.Fill[i]:SetPoint("RIGHT", self.Fill[i - 1]);
			end
		end

		local color = self.Colors[i];
		self.Fill[i]:SetVertexColor(color.R, color.G, color.B);
	end
end

local numFrames = 0; -- Local ID for naming, starts at 0 and will increment if a new frame is added

lib.__index = lib; -- Used to support OOP like code
function lib:New(parent)
	-- Increment ID
	numFrames = numFrames + 1;

	local frame = CreateFrame("Frame", "Krowi_ProgressBar" .. numFrames, parent, "Krowi_ProgressBar_Template");
	setmetatable(frame, setmetatable(lib, getmetatable(frame)));

	frame:SetScript("OnSizeChanged", function()
		Resize(frame);
	end);
	hooksecurefunc(frame, "SetHeight", function(self, height, ignore)
		if not ignore then
			self.CustomHeight = height;
		end
	end);

	borderLeftRightWidth = frame.BorderLeftMiddle:GetWidth();
	borderTopBottomHeight = frame.BorderMiddleTop:GetHeight();
	borderLeftRightMiddleHeight = frame.BorderMiddleMiddle:GetHeight();

    return frame;
end

function lib:SetMinMaxValues(min, max)
	self.Min = min;
	self.Max = max;
end

function lib:SetValues(value1, value2, value3, value4)
	self.Values = {value1, value2, value3, value4};
end

function lib:SetColors(color1, color2, color3, color4)
	local black = {R = 0, G = 0, B = 0};
	color1 = color1 or black;
	color2 = color2 or black;
	color3 = color3 or black;
	color4 = color4 or black;
	self.Colors = {color1, color2, color3, color4};
end

function lib:UpdateTextures()
	Resize(self);
end

function lib:Reset()
	self.Min = 0;
	self.Max = 0;
	self.Values = {0, 0, 0, 0};
	local black = {R = 0, G = 0, B = 0};
	self.Colors = {black, black, black, black};
end

local progressBar;
local function AddProgressBar(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text)
	GameTooltip_AddBlankLinesToTooltip(gameTooltip, 1);
	local numLines = gameTooltip:NumLines();
	if ( not text ) then
		text = "";
	end
	progressBar:SetPoint("LEFT", gameTooltip:GetName().."TextLeft"..numLines, "LEFT", 0, -2);
	progressBar:SetPoint("RIGHT", gameTooltip, "RIGHT", -9, 0);
	progressBar:SetHeight(25);
	progressBar.Text:SetText(text);
	progressBar:SetMinMaxValues(min, max);
	progressBar:SetValues(value1, value2, value3, value4);
	progressBar:SetColors(color1, color2, color3, color4);
	progressBar:UpdateTextures();
	progressBar:Show();
	gameTooltip:SetMinimumWidth(140);
end

local isHooked;
function lib:ShowProgressBar(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text)
	if not progressBar then
		progressBar = self:New(gameTooltip);
	else
		progressBar:Reset();
	end
	AddProgressBar(gameTooltip, min, max, value1, value2, value3, value4, color1, color2, color3, color4, text);

	if not isHooked then
		hooksecurefunc(gameTooltip, "Hide", function(self)
			if progressBar then
				progressBar:Hide();
			end
		end);
		isHooked = true;
	end
end