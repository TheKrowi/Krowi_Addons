local _, addon = ...; -- Global addon namespace
local diagnostics = addon.Diagnostics; -- Local diagnostics namespace

function KrowiAF_AchievementCategoryButton_OnClick(self, button, down, quick) -- Used in Templates - KrowiAF_AchievementCategoryTemplate
    diagnostics.Trace("KrowiAF_AchievementCategoryButton_OnClick for " .. self.name);

    self.ParentContainer.ParentFrame.Parent:SelectButton(self, quick);
    self.ParentContainer.ParentFrame.Parent:Update();
end