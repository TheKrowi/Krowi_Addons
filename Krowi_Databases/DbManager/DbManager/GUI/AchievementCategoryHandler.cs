﻿using DbManager.DataManagers;
using DbManager.Objects;
using Microsoft.Data.Sqlite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;

namespace DbManager.GUI
{
    public class AchievementCategoryHandler : IGUIHandler
    {
        private TreeView tvwAchievementCategories;
        private AchievementCategoryDataManager dataManager;
        private FunctionHandler functionHandler;

        public AchievementCategoryHandler(TreeView tvwAchievementCategories, AchievementCategoryDataManager dataManager, FunctionHandler functionHandler)
        {
            this.tvwAchievementCategories = tvwAchievementCategories;
            this.dataManager = dataManager;
            this.functionHandler = functionHandler;
        }

        public IDataManager DataManager => dataManager;

        public AchievementCategory GetSelectedAchievementCategory()
        {
            AchievementCategory selectedCategory = null;
            if (tvwAchievementCategories.SelectedNode != null)
                selectedCategory = ((AchievementCategoryTreeNode)tvwAchievementCategories.SelectedNode).AchievementCategory;

            return selectedCategory;
        }

        public AchievementCategoryTreeNode FindAchievementCategoryNode(TreeNodeCollection nodes, AchievementCategory category)
        {
            foreach (AchievementCategoryTreeNode node in nodes)
            {
                if (node.AchievementCategory.Equals(category))
                    return node;

                if (node.Nodes.Count > 0)
                {
                    var found = FindAchievementCategoryNode(node.Nodes, category);
                    if (found != null)
                        return found;
                }
            }

            return null;
        }

        public void RefreshTreeView()
        {
            // First get the selected category so we can select it again after the refresh
            var selectedCategory = GetSelectedAchievementCategory();

            tvwAchievementCategories.Nodes.Clear();

            var categories = dataManager.GetAll(true);

            foreach (var category in categories)
            {
                if (category.Parent == null)
                    tvwAchievementCategories.Nodes.Add(new AchievementCategoryTreeNode(category));
                else
                {
                    var node = FindAchievementCategoryNode(tvwAchievementCategories.Nodes, category.Parent);
                    if (node != null)
                        node.Nodes.Add(new AchievementCategoryTreeNode(category));
                }
            }

            if (selectedCategory != null)
            {
                var node = FindAchievementCategoryNode(tvwAchievementCategories.Nodes, selectedCategory);
                if (node != null)
                    tvwAchievementCategories.SelectedNode = node;
            }
        }

        public void Add(bool asParent, string achievementCategoryName, string functionValue, bool isLegacy)
        {
            var function = functionHandler.GetSelectedFunction();
            if (function == null)
            {
                MessageBox.Show("Invalid function selected!" + Environment.NewLine + Environment.NewLine + "Category is not added.", "Invalid function", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            var selectedCategory = GetSelectedAchievementCategory();
            if (selectedCategory == null)
            {
                MessageBox.Show("No category selected!" + Environment.NewLine + Environment.NewLine + "Category is not added.", "No category", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            int location = asParent ? 1 : selectedCategory.Location + 1;
            AchievementCategory parent = asParent ? selectedCategory : selectedCategory.Parent;

            achievementCategoryName = string.IsNullOrEmpty(achievementCategoryName) ? function.Description : achievementCategoryName;
            var category = new AchievementCategory()
            {
                Location = location,
                Name = achievementCategoryName,
                Parent = parent,
                Function = function,
                FunctionValue = functionValue,
                Legacy = isLegacy
            };
            dataManager.Add(category);

            if (!asParent)
            {
                var node = FindAchievementCategoryNode(tvwAchievementCategories.Nodes, parent);
                TreeNodeCollection nodes = null;
                if (node != null && node.Nodes != null)
                    nodes = node.Nodes;
                else
                    nodes = tvwAchievementCategories.Nodes;

                nodes.Insert(tvwAchievementCategories.SelectedNode.Index + 1, new AchievementCategoryTreeNode(category)); // Need to add this to ensure correct location numbers

                var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();

                dataManager.UpdateLocations(dataManager.GetLast(), categories);
            }

            RefreshTreeView();

            // Make sure the last added achievement category is selected
            category = dataManager.GetLast();
            var selectNode = FindAchievementCategoryNode(tvwAchievementCategories.Nodes, category);
            tvwAchievementCategories.SelectedNode = selectNode;
        }

        public void Remove()
        {
            var selectedCategory = GetSelectedAchievementCategory();
            if (selectedCategory == null)
            {
                MessageBox.Show("No category selected!" + Environment.NewLine + Environment.NewLine + "Category is not added.", "No category", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            dataManager.Remove(selectedCategory);

            var node = tvwAchievementCategories.SelectedNode.Parent;
            TreeNodeCollection nodes = null;
            if (node != null && node.Nodes != null)
                nodes = node.Nodes;
            else
                nodes = tvwAchievementCategories.Nodes;

            tvwAchievementCategories.SelectedNode.Remove();

            var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();
            dataManager.UpdateLocations(selectedCategory, categories);

            RefreshTreeView();
        }

        public void UpdateMapIDs(string mapIDsString)
        {
            //List<int> mapIDs;
            //if (string.IsNullOrEmpty(mapIDsString))
            //    mapIDs = new List<int>();
            //else
            //    mapIDs = mapIDsString.Split(',').Select(x => int.Parse(x.Trim())).ToList();
            //dataManager.UpdateMapIDs(GetSelectedAchievementCategory(), mapIDs);
        }

        public void MoveUp()
        {
            var selectedCategory = GetSelectedAchievementCategory();

            var node = tvwAchievementCategories.SelectedNode.Parent;
            TreeNodeCollection nodes = null;
            if (node != null && node.Nodes != null)
                nodes = node.Nodes;
            else
                nodes = tvwAchievementCategories.Nodes;

            var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();

            var filteredIndex = categories.FindIndex(x => x == selectedCategory);

            if (filteredIndex == 0) // Already top element so can't go up
                return;

            dataManager.Swap(categories[filteredIndex], categories[filteredIndex - 1]);

            RefreshTreeView();
        }

        public void MoveDown()
        {
            var selectedCategory = GetSelectedAchievementCategory();

            var node = tvwAchievementCategories.SelectedNode.Parent;
            TreeNodeCollection nodes = null;
            if (node != null && node.Nodes != null)
                nodes = node.Nodes;
            else
                nodes = tvwAchievementCategories.Nodes;

            var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();

            var filteredIndex = categories.FindIndex(x => x == selectedCategory);

            if (filteredIndex == categories.Count - 1) // Already bottom element so can't go down
                return;

            dataManager.Swap(categories[filteredIndex], categories[filteredIndex + 1]);

            RefreshTreeView();
        }

        public void MoveLeft()
        {
            var parentNode = (AchievementCategoryTreeNode)tvwAchievementCategories.SelectedNode.Parent;
            if (parentNode?.AchievementCategory is null)
                return;

            var selectedCategory = GetSelectedAchievementCategory();

            dataManager.UpdateParent(selectedCategory, selectedCategory.Parent.Parent, selectedCategory.Parent.Location + 1);

            var node = parentNode.Parent;
            TreeNodeCollection nodes = null;
            if (node != null && node.Nodes != null)
                nodes = node.Nodes;
            else
                nodes = tvwAchievementCategories.Nodes;

            nodes.Insert(parentNode.Index + 1, new AchievementCategoryTreeNode(selectedCategory)); // Need to add this to ensure correct location numbers

            var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();

            dataManager.UpdateLocations(selectedCategory, categories);

            var nextNode = (AchievementCategoryTreeNode)tvwAchievementCategories.SelectedNode.NextNode;
            if (nextNode is not null)
            {
                tvwAchievementCategories.SelectedNode.Remove();
                var prevNode = (AchievementCategoryTreeNode)nextNode.PrevNode;
                if (prevNode?.AchievementCategory is not null)
                {
                    var categories2 = prevNode.Parent.Nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();
                    dataManager.UpdateLocations(prevNode.AchievementCategory, categories2);
                }
                else // removed item was 1st element so we use next element and adjust from a fictional 1st element
                {
                    var categories2 = nextNode.Parent.Nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();
                    dataManager.UpdateLocations(new AchievementCategory(), categories2);
                }
            }

            RefreshTreeView();
        }

        public void MoveRight()
        {
            var prevNode = (AchievementCategoryTreeNode)tvwAchievementCategories.SelectedNode.PrevNode;
            if (prevNode?.AchievementCategory is null)
                return;

            var selectedCategory = GetSelectedAchievementCategory();

            var location = 1;
            if (prevNode.Nodes.Count > 0)
                location = ((AchievementCategoryTreeNode)prevNode.Nodes[prevNode.Nodes.Count - 1]).AchievementCategory.Location + 1;

            dataManager.UpdateParent(selectedCategory, prevNode.AchievementCategory, location);

            var node = tvwAchievementCategories.SelectedNode.Parent;
            TreeNodeCollection nodes = null;
            if (node != null && node.Nodes != null)
                nodes = node.Nodes;
            else
                nodes = tvwAchievementCategories.Nodes;

            tvwAchievementCategories.SelectedNode.Remove();

            var categories = nodes.Cast<AchievementCategoryTreeNode>().Select(x => x.AchievementCategory).ToList();

            dataManager.UpdateLocations(prevNode.AchievementCategory, categories);

            RefreshTreeView();
        }

        public void ChangeActiveState(bool active)
        {
            var selectedCategory = GetSelectedAchievementCategory();
            selectedCategory.Active = active;
            dataManager.ChangeActiveState(selectedCategory);
            //RefreshTreeView();
        }

        public void ChangeCanMergeState(bool canMerge)
        {
            var selectedCategory = GetSelectedAchievementCategory();
            selectedCategory.CanMerge = canMerge;
            dataManager.ChangeCanMergeState(selectedCategory);
            //RefreshTreeView();
        }
    }
}