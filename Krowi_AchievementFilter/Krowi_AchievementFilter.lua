print(GetDifficultyInfo(3));
print(GetDifficultyInfo(4));
print(GetDifficultyInfo(5));
print(GetDifficultyInfo(6));

-- function KrowiAF.InGuildView_Old()
--     return AchievementFrameHeaderTitle:GetText() == GUILD_ACHIEVEMENTS_TITLE;
-- end

-- KrowiAF.TabFunctions = {
--     categoryAccessor = function()
--         return KrowiAF.Categories_Old;
--     end,
--     getCategoryList = KrowiAF.AchievementFrameCategories_GetCategoryList_Old,
--     clearFunc = AchievementFrameAchievements_ClearSelection,
--     updateFunc = KrowiAF.AchievementFrameAchievements_Update_Old,
--     selectedCategory = 1;
--     noSummary = true;
-- };

-- TEST={};
-- KrowiAF.counter = 0;
-- KrowiAF.interval = 100;
-- KrowiAF.step = 0;
-- KrowiAF.max = 20000;
-- -- Globals Section
-- MyAddon_UpdateInterval = 1.0; -- How often the OnUpdate code will run (in seconds)

-- -- Functions Section
-- function MyAddon_OnUpdate(self, elapsed)
--   self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed; 	

--   if (self.TimeSinceLastUpdate > MyAddon_UpdateInterval) then
  
--   if KrowiAF.step < KrowiAF.max then
--     KrowiAF.counter = KrowiAF.step;
--     KrowiAF.step = KrowiAF.step + KrowiAF.interval;
--    for i = KrowiAF.counter, KrowiAF.step do
--        local id, name = GetAchievementInfo(i);
--        print("Achievement " .. tostring(id) .. " - " .. tostring(name));
--        tinsert(TEST, {id, name});
--    end
-- end

--     self.TimeSinceLastUpdate = 0;
--   end
-- end

local loadHelper = CreateFrame("Frame", nil, nil);
-- loadHelper.TimeSinceLastUpdate = 0;
loadHelper:RegisterEvent("ADDON_LOADED");
-- loadHelper:SetScript("OnUpdate", MyAddon_OnUpdate);

function loadHelper:OnEvent(event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "Krowi_AchievementFilter" then
            KrowiAF.LoadOptions(); -- 1
            KrowiAF.LoadIcon(); -- 2
        elseif arg1 == "Blizzard_AchievementUI" then
            -- local tab = KrowiAF.AchievementTab_Old:AddNewTab(AF_TAB_BUTTON_TEXT .. "OLD", KrowiAF.TabFunctions); -- 4
            -- KrowiAF.Debug("     - Functions linked");
            -- hooksecurefunc("AchievementFrameBaseTab_OnClick", tab.LeaveTab);
            -- hooksecurefunc("AchievementFrameComparisonTab_OnClick", tab.LeaveTab);
            -- KrowiAF.Debug("     - LeaveTab hooked");
            -- KrowiAF.LoadCategories(); -- 5
            -- KrowiAF.LoadAchievements(); -- 6
            -- local loaded, reason = LoadAddOn("AchievementFilter_Tab");
            -- KrowiAF.Debug(loaded);
            -- KrowiAF.Debug(reason);
            self:UnregisterEvent("ADDON_LOADED");
        end
    end
end
loadHelper:SetScript("OnEvent", loadHelper.OnEvent);