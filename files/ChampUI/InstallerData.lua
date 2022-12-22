local  RUI = select(2, ...):unpack()

local E, L, V, P, G = unpack(ElvUI)

--This is the data we pass on to the ElvUI Plugin Installer.
--The Plugin Installer is responsible for displaying the install guide for this layout.
CUI.InstallerData = {
	Title = format("|cffc41f3b%s %s|r", CUI.PluginName, "Installation"),
	Name = CUI.PluginName,
	tutorialImage = "Interface\\AddOns\\ElvUI_Redtuzk\\Media\\logo.tga", --If you have a logo you want to use, otherwise it uses the one from ElvUI
	Pages = {
		[1] = function() --Welcome
			if E.db[CUI.PluginName].install_version == nil and E["global"][CUI.PluginName].profile_name then
				PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", CUI.PluginName)
				PluginInstallFrame.Desc1:SetText("It looks like you already have a RedtuzkUI profile installed called |cffc41f3b"..E["global"][CUI.PluginName].profile_name.."|r. Click \"Use Original\" to use the same profile on this character")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", CUI.LoadRUIProfile)
				PluginInstallFrame.Option1:SetText("Use Original")
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", CUI.InstallComplete)
				PluginInstallFrame.Option2:SetText("Skip Process")
			elseif E.db[CUI.PluginName].install_version == CUI.Version or E.db[CUI.PluginName].install_version == nil then
				PluginInstallFrame.Desc1:SetText("This installation process will guide you through a few steps and apply settings to your current ElvUI profile. If you want to be able to go back to your original settings then create a new profile before going through this installation process.")
				PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", CUI.InstallComplete)
				PluginInstallFrame.Option1:SetText("Skip Process")
			else
				PluginInstallFrame.SubTitle:SetFormattedText("|cff00ff00Looks like you've downloaded an update for|r |cffc41f3b%s|r!", CUI.PluginName)
				PluginInstallFrame.Desc1:SetText("Please go through the installer again to update parts of the UI you'd like updated.\n\n\nAny changes that you've made from the default RedtuzkUI profile will be removed.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", CUI.InstallComplete)
				PluginInstallFrame.Option1:SetText("Skip Update")
			end
      local MissingAddons = ""
      if (not IsAddOnLoaded("ElvUI_SLE") or not IsAddOnLoaded("AddonSkins")) then
        MissingAddons = "|cffff0000Caution! Some features won't work until you install/load|r "
        if  not IsAddOnLoaded("ElvUI_SLE") then
          MissingAddons = MissingAddons.."|cff9482c9Shadow and Light|r"
        end
        if not IsAddOnLoaded("ElvUI_SLE") and not IsAddOnLoaded("AddonSkins") then
          MissingAddons = MissingAddons.."||cffff0000 and |r"
        end
        if not IsAddOnLoaded("AddonSkins") then
          MissingAddons = MissingAddons.."|cff1784d1AddonSkins|r"
        end
      end
      PluginInstallFrame.Desc3:SetText(MissingAddons)
		end,
		[2] = function() --Profile Setup
			if E.db[CUI.PluginName].install_version == nil or E.db[CUI.PluginName].install_version == CUI.Version then
				PluginInstallFrame.SubTitle:SetText("Profiles")
				PluginInstallFrame.Desc1:SetText("You can either create a new profile to install RedtuzkUI onto or you can apply RedtuzkUI settings to your current profile")
				PluginInstallFrame.Desc3:SetText("Your currently active ElvUI profile is: |cffc41f3b"..ElvUI[1].data:GetCurrentProfile().."|r")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:NewProfile(false) end)
				PluginInstallFrame.Option1:SetText("Use Current")
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", function() RUI:NewProfile(true, "RedtuzkUI") end)
				PluginInstallFrame.Option2:SetText("Create New")
			else
				PluginInstallFrame.SubTitle:SetText("Profiles")
				PluginInstallFrame.Desc1:SetText("Press \"Update Current\" to update your current profile with the new RedtuzkUI changes.")
				PluginInstallFrame.Desc2:SetText("If you'd like to check out what the changes are, without overwriting your current settings, you can press \"Create New\"")
				PluginInstallFrame.Desc3:SetText("Your currently active ElvUI profile is: |cffc41f3b"..ElvUI[1].data:GetCurrentProfile().."|r")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:NewProfile(false) end)
				PluginInstallFrame.Option1:SetText("Update Current")
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", function() RUI:NewProfile(true, "RedtuzkUI-Update") end)
				PluginInstallFrame.Option2:SetText("Create New")
			end
		end,
		[3] = function() --Layout
			PluginInstallFrame.SubTitle:SetText("Layout")
			if not (E.db[CUI.PluginName].layout == "Aldarana" or E.db[CUI.PluginName].layout == "Redtuzk") then
				E.db[CUI.PluginName].layout = nil
			end
			if E.db[CUI.PluginName].install_version == nil or E.db[CUI.PluginName].install_version == CUI.Version or not E.db[CUI.PluginName].layout then
				PluginInstallFrame.Desc1:SetText("We offer two different layouts. The \"|cffeb5252Redtuzk|r\" layout is new layout custom made by Redtuzk. The \"|cff41a24cAldarana|r\" layout is the old RUI layout maintainted by our dev Aldarana")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupLayout("Redtuzk"); E.db[CUI.PluginName].layout = "Redtuzk" end)
				PluginInstallFrame.Option1:SetText("|cffeb5252Redtuzk|r")
				PluginInstallFrame.Option2:Show()
				PluginInstallFrame.Option2:SetScript("OnClick", function() RUI:SetupLayout("Aldarana"); E.db[CUI.PluginName].layout = "Aldarana" end)
				PluginInstallFrame.Option2:SetText("|cff41a24cAldarana|r")
			else
				PluginInstallFrame.Desc1:SetText("Press \"Update Layout\" to update your ElvUI profile.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupLayout(E.db[CUI.PluginName].layout) end)
				PluginInstallFrame.Option1:SetText("Update Layout")
			end
		end,
		[4] = function() --NamePlates
			if (E.db[CUI.PluginName].layout == "Redtuzk" or E.db[CUI.PluginName].layout == "Aldarana") and IsAddOnLoaded("Plater") then
		    PluginInstallFrame.SubTitle:SetText("NamePlates")
				PluginInstallFrame.Desc1:SetText("We highly recommend using Plater nameplates. \n When you click \"Setup Plater\" a new Plater profile called RedtuzkUI will be created.")
				PluginInstallFrame.Option1:Show()
				PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:NamePlateSettings() end)
				PluginInstallFrame.Option1:SetText("Plater")
			else
				PluginInstallFrame.SubTitle:SetText("NamePlates")
				PluginInstallFrame.Desc1:SetText("We highly recommend using Plater nameplates. \n When you click \"Setup Plater\" a new Plater profile called RedtuzkUI will be created.")
				PluginInstallFrame.Desc2:SetText("|cffB33A3AOops! Looks like you haven't opted to use either of our avaiable layouts OR you don't have Plater. We don't have any nameplates settings to offer you.|r")
				--User doesn't have Plater so assume they want ElvUI plates
				E.db[CUI.PluginName]["plater"] = false
			end
		end,
		[5] = function() --Boss Mod
			if IsAddOnLoaded("BigWigs") and (E.db[CUI.PluginName].layout == "Redtuzk" or E.db[CUI.PluginName].layout == "Aldarana") then --Make sure the User has BigWigs installed.
				PluginInstallFrame.SubTitle:SetText("BigWigs")
				if E.db[CUI.PluginName].install_version == nil or E.db[CUI.PluginName].install_version == CUI.Version then
					PluginInstallFrame.Desc1:SetText("Import Redtuzk's BigWigs profile. A new profile called RedtuzkUI will be created. If you already have the Redtuzk profile it will be updated.")
					PluginInstallFrame.Desc2:SetText("Requires a UI reload for profile switch to take effect")
					PluginInstallFrame.Option1:Show()
					PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupBigWigs() end)
					PluginInstallFrame.Option1:SetText("Setup BigWigs")
				else
					PluginInstallFrame.Desc1:SetText("Click \"Update BigWigs\" to update the RedtuzkUI BigWigs profile.\n\nCustom Settings for bosses will |cff07D400NOT|r be altered.")
					PluginInstallFrame.Desc2:SetText("Requires a UI reload for profile changes to take effect")
					PluginInstallFrame.Option1:Show()
					PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupBigWigs() end)
					PluginInstallFrame.Option1:SetText("Update BigWigs")
				end
			else
				PluginInstallFrame.SubTitle:SetText("Boss Mod")
				PluginInstallFrame.Desc1:SetText("|cffB33A3AOops, it looks like you don't have BigWigs installed OR haven't selected a layout!|r")
				PluginInstallFrame.Desc2:SetText("BigWigs is recommended for use with RedtuzkUI")
			end
		end,
		[6] = function() --Details
			PluginInstallFrame.SubTitle:SetText("Details")
			if IsAddOnLoaded("Details") then --Make sure the User has Details installed.
				if E.db[CUI.PluginName].install_version == nil or E.db[CUI.PluginName].install_version == CUI.Version then
					PluginInstallFrame.Desc1:SetText("Import Redtuzk's Details profile. A new profile called RedtuzkUI will be created. If you already have the Redtuzk profile it will be updated.")
					PluginInstallFrame.Option1:Show()
					PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupDetails() end)
					PluginInstallFrame.Option1:SetText("Setup Details")
				else
					PluginInstallFrame.Desc1:SetText("Click \"Update Details\" to update the RedtuzkUI Details profile.")
					PluginInstallFrame.Option1:Show()
					PluginInstallFrame.Option1:SetScript("OnClick", function() RUI:SetupDetails() end)
					PluginInstallFrame.Option1:SetText("Update Details")
				end
			else
				PluginInstallFrame.Desc1:SetText("|cffB33A3AOops, it looks like you don't have Details installed!|r")
				PluginInstallFrame.Desc2:SetText("Details is recommended for use with RedtuzkUI")
			end
		end,
		[7] = function() -- Install Complete
			if E.db[CUI.PluginName].install_version == nil or E.db[CUI.PluginName].install_version == CUI.Version then
				PluginInstallFrame.SubTitle:SetText("Installation Complete")
				PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
				PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			else
				PluginInstallFrame.SubTitle:SetText("Update Complete")
				PluginInstallFrame.Desc1:SetText("You have completed the update process.")
				PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			end
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", CUI.InstallComplete)
			PluginInstallFrame.Option1:SetText("Finished")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", createLink)
			PluginInstallFrame.Option2:SetText("Join Discord")
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "Profile Setup",
		[3] = "Layout",
		[4] = "NamePlates",
		[5] = "Boss Mod Setup",
		[6] = "Details Setup",
		[7] = "Installation Complete",
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {0.769, 0.122, 0.231},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "RIGHT",
}
