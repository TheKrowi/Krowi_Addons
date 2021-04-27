﻿using DbManager.Objects;
using System.Windows.Forms;

namespace DbManager.GUI
{
    public class AchievementCategoryTreeNode : TreeNode
    {
        public AchievementCategory AchievementCategory { get; set; }

        public AchievementCategoryTreeNode(AchievementCategory achievementCategory)
        {
            AchievementCategory = achievementCategory;
            Text = $"{achievementCategory.Location} - {achievementCategory}";
            Name = achievementCategory.ID.ToString();
        }
    }
}