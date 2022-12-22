local addon, _ = ...
local Version = GetAddOnMetadata(addon, "Version")
local  CUI = select(2, ...):unpack()

--This is the data we pass on to the ElvUI Plugin Installer.
--The Plugin Installer is reponsible for displaying the install guide for this layout.
CUI.InstallerData = {
	Title = format("%s %s", CUI.PluginName, "Installation"),
	Name = CUI.PluginName,
	Pages = {
		[1] = function() --Welcome
			if ChampUI_DB.global and ChampUI_DB.global.installed then
				PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", CUI.PluginName)
				PluginInstallFrame.Desc1:SetFormattedText("It looks like you've installed %s before. If you'd like to load the same ChampUI profiles on this character you can click 'Load Profiles'.", CUI.PluginName)
				PluginInstallFrame.Desc2:SetText("If you'd like to go through the installation again you can click the continue button. |cffff0000!!WARNING:!!|r Doing so will reset all of your profiles again. You can also click 'Skip Process' if you don't want the Naowh profiles on this character.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", CUI.LoadCUIProfiles)
				PluginInstallFrame.Option1:SetText("Load Profiles")
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", CUI.InstallComplete)
				PluginInstallFrame.Option2:SetText("Skip Process")
			else
				CUI:Notice("NOTICE! \n\nAs you go through the installer you might not see some changes. Some settings are not applied until you reload. A reload will happen automatically at the end of the installer.")
				PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", CUI.PluginName)
				PluginInstallFrame.Desc1:SetText("This installation process will guide you through steps to set ChampUI for various addons. NOTICE! As you go through the installer you won't see any changes. Changes will not be visible until you reload. A reload will happen automatically at the end of the installer.\n|cffff0000!!WARNING:!!|r Running the installer will cause ALL settings for the addons in it to be wiped. If you'd like to keep any of your settings back up your WTF file NOW!")
				PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", CUI.InstallComplete)
				PluginInstallFrame.Option1:SetText("Skip Process")
			end
		end,
		[2] = function() --Layouts
			PluginInstallFrame.SubTitle:SetText("Layouts")
			PluginInstallFrame.Desc1:SetText("These are the layouts that are available. Please click a button below to apply the layout of your choosing.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() CUI:ElvUIImport("normal", true) end)
			PluginInstallFrame.Option1:SetText("DPS & Tank")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() CUI:ElvUIImport("healer", true) end)
			PluginInstallFrame.Option2:SetText("Healer")
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() CUI:ElvUIImport("cwa", true) end)
			PluginInstallFrame.Option3:SetText("Class WA")
		end,
		[3] = function() --BigWigs
			PluginInstallFrame.SubTitle:SetFormattedText("BigWigs")
			PluginInstallFrame.Desc1:SetText("Import ChampUI BigWigs profile.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() CUI:BigWigsImport(true) end)
			PluginInstallFrame.Option1:SetText("Setup BigWigs")
		end,
		[4] = function() --Details
			PluginInstallFrame.SubTitle:SetFormattedText("Details")
			PluginInstallFrame.Desc1:SetText("Import Naowh's Details profile")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() CUI:DetailsImport(true) end)
			PluginInstallFrame.Option1:SetText("Setup Details")
		end,
		[5] = function() --Plater
			PluginInstallFrame.SubTitle:SetFormattedText("Plater")
			PluginInstallFrame.Desc1:SetText("Import Naowh's Plater profile.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() CUI:PlaterImport(true) end)
			PluginInstallFrame.Option1:SetText("Setup Plater")
		end,
		[6] = function() --End
			PluginInstallFrame.SubTitle:SetText("Installation Complete")
			PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
			PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", CUI.InstallComplete)
			PluginInstallFrame.Option1:SetText("Finished")
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "Layouts",
		[3] = "BigWigs",
		[4] = "Details",
		[5] = "Plater",
		[6] = "Installation Complete",
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {0, 179/255, 1},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "RIGHT",
}
