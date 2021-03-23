-- [[ Namespaces ]] --
local _, addon = ...;
local diagnostics = addon.Diagnostics;
local objects = addon.Objects;
objects.Achievement = {};
local achievement = objects.Achievement;

-- [[ Constructors ]] --
achievement.__index = achievement;
function achievement:New(id, faction, covenant, obtainable, hasWowheadLink, --[[ hasIATLink, ]] category) -- Creates a new achievement
    local self = {};
    setmetatable(self, achievement);

    self.ID = id or 0;
    self.Faction = faction;
    self.Covenant = covenant;
    if obtainable == false then -- We only want to set it if it's not obtainable, otherwise nil
        self.NotObtainable = true; -- By inverting this we reduce memory usage because 99% is obtainable
    end
    if hasWowheadLink == false then -- We only want to set it if it has no Wowhead link, otherwise nil
        self.HasNoWowheadLink = true; -- By inverting this we reduce memory usage because 99% has a Wowhead link
    end
    -- self.HasIATLink = hasIATLink;
    self.Category = category;

    return self;
end

-- [[ Methods ]] --
function achievement:AddRCMenExtra(rcMenExtra) -- Adds extra content to the achievement's right click menu, calling this method multiple times will overwrite the previous call
    self.RCMenExtra = rcMenExtra;
end

function achievement:GetCategory() -- Gets the achievement's category
    diagnostics.Trace("achievement:GetCategory");

     -- Addition: needed for achievement that are in our database more than once and searching for the category would always return the first found
    if self.Category then
        return self.Category;
    end

    -- If the achievement has no category (only once in the database), it's safe to look for the first category with this achievement in it
    for _, category in next, addon.Categories do
        if category.Achievements ~= nil then
            for _, ach in next, category.Achievements do
                if ach.ID == self.ID then
                    return category;
                end
            end
        end
    end

    error("The achievement with ID " .. self.ID .. " has no category."); -- Should in theory never happen, means there is a problem with the database
end