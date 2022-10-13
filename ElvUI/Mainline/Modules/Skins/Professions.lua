local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local pairs, select = pairs, select
local hooksecurefunc = hooksecurefunc

local function HandleInputBox(box)
	box:DisableDrawLayer('BACKGROUND')
	S:HandleEditBox(box)
	S:HandleNextPrevButton(box.DecrementButton, 'left')
	S:HandleNextPrevButton(box.IncrementButton, 'right')
end

local function ReskinQualityContainer(container)
	local button = container.Button
	button:StripTextures()
	button:ClearNormalTexture()
	button:ClearPushedTexture()
	button:ClearHighlightTexture()
	S:HandleIcon(button.Icon, true)
	S:HandleIconBorder(button.IconBorder, button.Icon.backdrop) -- ToDO: WoW10
	HandleInputBox(container.EditBox)
end

local function ReskinSlotButton(button)
	if button and not button.isSkinned then
		button:StripTextures()
		button:ClearNormalTexture()
		button:ClearPushedTexture()

		S:HandleIcon(button.Icon, true)
		S:HandleIconBorder(button.IconBorder, button.Icon.backdrop)

		local hl = button:GetHighlightTexture()
		hl:SetColorTexture(1, 1, 1, .25)
		hl:SetInside(button.bg)
		if button.SlotBackground then
			button.SlotBackground:Hide()
		end

		button.isSkinned = true
	end
end

function S:Blizzard_Professions()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.tradeskill) then return end

	local ProfessionsFrame = _G.ProfessionsFrame
	S:HandlePortraitFrame(ProfessionsFrame)

	local CraftingPage = ProfessionsFrame.CraftingPage
	CraftingPage.TutorialButton.Ring:Hide()
	S:HandleButton(CraftingPage.CreateButton)
	S:HandleButton(CraftingPage.CreateAllButton)
	S:HandleButton(CraftingPage.ViewGuildCraftersButton)
	HandleInputBox(CraftingPage.CreateMultipleInputBox)

	local RankBar = CraftingPage.RankBar
	RankBar.Border:Hide()
	RankBar.Background:Hide()
	RankBar.Fill:CreateBackdrop()

	local LinkButton = CraftingPage.LinkButton
	LinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75)
	LinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)
	LinkButton:GetHighlightTexture():Kill()
	LinkButton:SetTemplate()
	LinkButton:Size(17, 14)

	local GuildFrame = CraftingPage.GuildFrame
	GuildFrame:StripTextures()
	GuildFrame:CreateBackdrop('Transparent')
	GuildFrame.Container:StripTextures()
	GuildFrame.Container:CreateBackdrop('Transparent')

	for i = 1, 2 do
		local tab = select(i, ProfessionsFrame.TabSystem:GetChildren())
		S:HandleTab(tab)
	end

	for _, name in pairs({'Prof0ToolSlot', 'Prof0Gear0Slot', 'Prof0Gear1Slot', 'Prof1ToolSlot', 'Prof1Gear0Slot', 'Prof1Gear1Slot', 'CookingToolSlot', 'CookingGear0Slot', 'FishingToolSlot', 'FishingGear0Slot', 'FishingGear1Slot'}) do
		local button = CraftingPage[name]
		if button then
			button:StripTextures()
			S:HandleIcon(button.icon, true)
			S:HandleIconBorder(button.IconBorder, button.icon.backdrop) -- ToDO: WoW10 Fix Icon Border
			button:ClearNormalTexture()
			button:ClearPushedTexture()
		end
	end

	local RecipeList = CraftingPage.RecipeList
	RecipeList:StripTextures()
	S:HandleTrimScrollBar(RecipeList.ScrollBar, true)
	if RecipeList.BackgroundNineSlice then RecipeList.BackgroundNineSlice:Hide() end
	RecipeList:CreateBackdrop('Transparent')
	RecipeList.backdrop:SetInside()
	S:HandleEditBox(RecipeList.SearchBox)
	S:HandleButton(RecipeList.FilterButton)

	local SchematicForm = CraftingPage.SchematicForm
	SchematicForm:StripTextures()
	SchematicForm.Background:SetAlpha(0)
	SchematicForm:CreateBackdrop('Transparent')
	SchematicForm.backdrop:SetInside()

	local Track = SchematicForm.TrackRecipeCheckBox
	if Track then
		S:HandleCheckBox(Track)
		Track:SetSize(24, 24)
	end

	local QualityCheckBox = SchematicForm.AllocateBestQualityCheckBox
	if QualityCheckBox then
		S:HandleCheckBox(QualityCheckBox)
		QualityCheckBox:SetSize(24, 24)
	end

	local QualityDialog = SchematicForm.QualityDialog
	if QualityDialog then
		QualityDialog:StripTextures()
		QualityDialog:CreateBackdrop('Transparent')
		S:HandleCloseButton(QualityDialog.ClosePanelButton)
		S:HandleButton(QualityDialog.AcceptButton)
		S:HandleButton(QualityDialog.CancelButton)

		ReskinQualityContainer(QualityDialog.Container1)
		ReskinQualityContainer(QualityDialog.Container2)
		ReskinQualityContainer(QualityDialog.Container3)
	end

	hooksecurefunc(SchematicForm, 'Init', function(frame)
		for slot in frame.reagentSlotPool:EnumerateActive() do
			ReskinSlotButton(slot.Button)
		end

		local slot = SchematicForm.salvageSlot
		if slot then
			ReskinSlotButton(slot.Button)
		end
	end)

	local SpecPage = ProfessionsFrame.SpecPage
	S:HandleButton(SpecPage.UnlockTabButton)
	S:HandleButton(SpecPage.ApplyButton)
	SpecPage.TreeView:StripTextures()
	SpecPage.TreeView.Background:Hide()
	SpecPage.TreeView:CreateBackdrop('Transparent')
	SpecPage.TreeView.backdrop:SetInside()

	hooksecurefunc(SpecPage, 'UpdateTabs', function(frame)
		for tab in frame.tabsPool:EnumerateActive() do
			if not tab.isSkinned then
				S:HandleTab(tab)
				tab.isSkinned = true
			end
		end
	end)

	local DetailedView = SpecPage.DetailedView
	DetailedView:StripTextures()
	DetailedView:CreateBackdrop('Transparent')
	DetailedView.backdrop:SetInside()
	S:HandleButton(DetailedView.UnlockPathButton)
	S:HandleButton(DetailedView.SpendPointsButton)
	S:HandleIcon(DetailedView.UnspentPoints.Icon)

	local OutputLog = CraftingPage.CraftingOutputLog
	OutputLog:StripTextures()
	OutputLog:CreateBackdrop()
	S:HandleCloseButton(OutputLog.ClosePanelButton)
	S:HandleTrimScrollBar(OutputLog.ScrollBar, true)

	hooksecurefunc(OutputLog.ScrollBox, 'Update', function(frame)
		for i = 1, frame.ScrollTarget:GetNumChildren() do
			local child = select(i, frame.ScrollTarget:GetChildren())
			if not child.isSkinned then
				local itemContainer = child.ItemContainer
				if itemContainer then
					local item = itemContainer.Item
					item:ClearNormalTexture()
					item:ClearPushedTexture()
					item:ClearHighlightTexture()

					local icon = item:GetRegions()
					S:HandleIcon(icon, true)
					S:HandleIconBorder(item.IconBorder, icon.backdrop)
					itemContainer.CritFrame:SetAlpha(0)
					itemContainer.BorderFrame:Hide()
					itemContainer.HighlightNameFrame:SetAlpha(0)
					itemContainer.PushedNameFrame:SetAlpha(0)
					itemContainer.HighlightNameFrame:CreateBackdrop('Transparent')
				end

				local bonus = child.CreationBonus
				if bonus then
					local item = bonus.Item
					item:StripTextures()
					local icon = item:GetRegions()
					S:HandleIcon(icon)
				end

				child.isSkinned = true
			end

			local itemContainer = child.ItemContainer
			if itemContainer then
				itemContainer.Item.IconBorder:SetAlpha(0)

				local itemBG = itemContainer.backdrop
				if itemBG then
					if itemContainer.CritFrame:IsShown() then
						itemBG:SetBackdropBorderColor(1, .8, 0)
					else
						itemBG:SetBackdropBorderColor(0, 0, 0)
					end
				end
			end
		end
	end)
end

S:AddCallbackForAddon('Blizzard_Professions')
