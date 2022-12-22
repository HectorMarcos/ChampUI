local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")
local addon, engine = ...
engine[1] = {}

function engine:unpack()
	return self[1]
end

CUI = engine [1]
CUI.Version = Version

--Cache Lua / WoW API
local format = string.format
local GetCVarBool = GetCVarBool
local ReloadUI = ReloadUI
local StopMusic = StopMusic

-- These are things we do not cache
-- GLOBALS: PluginInstallStepComplete, PluginInstallFrame

--Change this line and use a unique name for your plugin.
CUI.PluginName = "ChampUI"

--Create references to ElvUI internals
local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local NP = E:GetModule('NamePlates')

--Create reference to LibElvUIPlugin
local EP = LibStub("LibElvUIPlugin-1.0")

--Create a new ElvUI module so ElvUI can handle initialization when ready
local mod = E:NewModule(CUI.PluginName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");

--Store the Discord link
discordLink = ""

--Runs for the step questioning the user if they want a new ElvUI profile
function RUI:NewProfile(new)
	if (new) then -- the user clicked "Create New" create a dialog pop up
		StaticPopupDialogs["CreateProfileNameNew"] = {
		text = L["Name for the new profile"],
		button1 = L["Accept"],
		button2 = L["Cancel"],
		hasEditBox = 1,
		whileDead = 1,
		hideOnEscape = 1,
		timeout = 0,
		OnShow = function(self, data)
		  self.editBox:SetText("ChampUI"); --default text in the editbox
		end,
		OnAccept = function(self, data, data2)
		  local text = self.editBox:GetText()
		  ElvUI[1].data:SetProfile(text) --ElvUI function for changing profiles, creates a new profile if name doesn't exist
			E.private[CUI.PluginName].profileName = text
		  PluginInstallStepComplete.message = "Profile Created"
		  PluginInstallStepComplete:Show()
		end
	  };
	  StaticPopup_Show("CreateProfileNameNew", "test"); --tell our dialog box to show
	elseif(new == false) then -- the user clicked "Use Current" create a dialog pop up
		StaticPopupDialogs["ProfileOverrideConfirm"] = {
			text = "Are you sure you want to override the current profile?",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
					E.private[CUI.PluginName].profileName = E.data:GetCurrentProfile();
			    PluginInstallStepComplete.message = "Profile Selected"
		      PluginInstallStepComplete:Show()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show("ProfileOverrideConfirm", "test")--tell our dialog box to show
	end
end

local function ElvUIUpdate()
	E:UpdateStart(true)
	E:UpdateLayout()
	E:UpdateTooltip()
	E:UpdateActionBars()
	E:UpdateBags()
	E:UpdateChat()
	E:UpdateDataBars()
	E:UpdateDataTexts()
	E:UpdateMinimap()
	E:UpdateAuras()
	E:UpdateMisc()
	E:UpdateEnd()
	if E.private.nameplates.enable then
		E:UpdateNamePlates()
	end
end

function CUI:SetupLayout(layout)
	if (layout == "ChampUI DPS & TANK") then
		if E.private[CUI.PluginName].profileName then
			RUI:ElvUIRedtuzk(E.private[CUI.PluginName].profileName)
		else
			RUI:ElvUIRedtuzk("ChampUI DPS & TANK")
		end
	elseif (layout == "ChampUI HEALER") then
		if E.private[CUI.PluginName].profileName then
			RUI:ElvUIAldarana(E.private[CUI.PluginName].profileName)
		else
			RUI:ElvUIAldarana("ChampUI HEALER")
		end
	end

	ElvUIUpdate()
	PluginInstallStepComplete.message = "Layout Set"
	PluginInstallStepComplete:Show()
end

function CUI:NamePlateSettings()
    CUI:PlaterChampUI()
    E.db[CUI.PluginName]["plater"] = true
    E.db[CUI.PluginName].platerName = "ChampUI"
    PluginInstallStepComplete.message = "Plater Profile Added"
	
	PluginInstallStepComplete:Show()
end

function CUI:SetupDetails()
    CUI:DetailsChampUI()
    _detalhes:ApplyProfile("ChampUI", false, false)
	PluginInstallStepComplete.message = "Details Profile Applied"
	PluginInstallStepComplete:Show()
end

function RUI:SetupBigWigs()
    --Check see if the BigWigs database exists
    if(BigWigs3DB) then
        --If it does add ChampUI to the profiles
        RUI:BigWigsChampUI()
    else
        --If it doesn't create the BigWigs database then add ChampUI to the profiles
        RUI:BigWigsFresh(E.db[CUI.PluginName].layout)
        RUI:BigWigsChampUI()
    end
    --Apply the RedtuzkUI profile
    local BigWigs = LibStub("AceDB-3.0"):New(BigWigs3DB)
    BigWigs:SetProfile("ChampUI")
	
	PluginInstallStepComplete.message = "BigWigs Profile Applied"
	PluginInstallStepComplete:Show()
end

local function createLink()
	StaticPopupDialogs["DiscordLinkDisplay"] = {
	text = L["Use the following link to join us on Discord"],
	button1 = L["Close"],
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	timeout = 0,
	OnShow = function(self, data)
		self.editBox:SetAutoFocus(false)
		self.editBox:SetWidth(150)
		self.editBox:SetText(discordLink); --default text in the editbox
		self.editBox:HighlightText()
	end,
	};
	StaticPopup_Show("DiscordLinkDisplay", "test"); --tell our dialog box to show
end

function CUI:LoadCUIProfile()
	local SLEv = GetAddOnMetadata("ElvUI_SLE", "Version")
	E.private.sle.install_complete = SLEv
	ElvUI[1].data:SetProfile(E["global"][CUI.PluginName].profile_name)
	E.private["general"]["chatBubbleFontSize"] = 12
    E.private["general"]["chatBubbleFont"] = "Century Gothic Bold"
    E.private["general"]["chatBubbleFontOutline"] = "OUTLINE"
    E.private["general"]["namefont"] = "Century Gothic Bold"
    E.private["general"]["dmgfont"] = "Century Gothic Bold"
    E.private["skins"]["blizzard"]["alertframes"] = true
    E.private["skins"]["blizzard"]["UIWidgets"] = true
	if IsAddOnLoaded("ElvUI_SLE") then
	    E.private["sle"]["pvpreadydialogreset"] = true
        E.private["sle"]["install_complete"] = "3.421"
	end
	if IsAddOnLoaded("ElvUI_CustomTweaks") then
	    E.private["CustomTweaks"]["CastbarText"] = true
        E.private["CustomTweaks"]["AuraIconSpacing"] = true
	end
	if IsAddOnLoaded("BigWigs") then
		SetupBigWigs()
	elseif IsAddOnLoaded("DBM-Core") then
		SetupDBM()
	end
	if IsAddOnLoaded("Details") then
		SetupDetails()
	end
	ReloadUI()
end
--This function is executed when you press "Skip Process" or "Finished" in the installer.
function CUI:InstallComplete()
	if GetCVarBool("Sound_EnableMusic") then
		StopMusic()
	end

    local SLEv = GetAddOnMetadata("ElvUI_SLE", "Version")
    E.private.sle.install_complete = SLEv

	E["global"][CUI.PluginName].profile_name = ElvUI[1].data:GetCurrentProfile()

	--Set a variable tracking the version of the addon when layout was installed
	E.db[CUI.PluginName].install_version = CUI.Version
	print(E.db[CUI.PluginName].install_version)
	--Plater dose not like it when you change profiles and requies a reload after so do it right before the reload
	if E.db[CUI.PluginName]["plater"] then
		Plater.db:SetProfile(E.db[CUI.PluginName].platerName)
		E.private["nameplates"]["enable"] = false
	elseif not E.db[CUI.PluginName]["plater"] then
		E.private["nameplates"]["enable"] = true
	end
	ReloadUI()
end


--This function holds the options table which will be inserted into the ElvUI config
local function InsertOptions()
	E.Options.args[CUI.PluginName] = {
		order = 100,
		type = "group",
		name = format("|cffc41f3b%s|r", CUI.PluginName),
		args = {
			header1 = {
				order = 1,
				type = "header",
				name = CUI.PluginName,
			},
			description1 = {
				order = 2,
				type = "description",
				name = format("%s is a layout for ElvUI.", CUI.PluginName),
			},
			discordlink = {
				order = 3, type = 'input', width = 'full', name = L["Join us on Discord!"],
				get = function(info) return discordLink end,
			},
			discordicon = {
				order = 4,
				type = "description",
				name = "",
				image = "Interface\\AddOns\\ChampUI\\media\\discord.tga",
				imageWidth = 256,
				imageHeight = 128,
				imageCoords = {0,1,0,1},
			},
			spacer1 = {
				order = 5,
				type = "description",
				name = "\n\n\n",
			},
			header2 = {
				order = 6,
				type = "header",
				name = "Installation",
			},
			description2 = {
				order = 7,
				type = "description",
				name = "The installation guide should pop up automatically after you have completed the ElvUI installation. If you wish to re-run the installation process for this layout then please click the button below.",
			},
			spacer2 = {
				order = 8,
				type = "description",
				name = "",
			},
			install = {
				order = 9,
				type = "execute",
				name = "Install/Update",
				desc = "Run the installation process.",
				func = function() E:GetModule("PluginInstaller"):Queue(CUI.InstallerData); E:ToggleOptionsUI(); end,
			},
			spacer3 = {
				order = 10,
				type = "description",
				name = "",
			},
		},
	}
end
--Create a unique table for our plugin
P[CUI.PluginName] = {}

--This function will handle initialization of the addon
function mod:Initialize()
	--Initiate installation process if ElvUI install is complete and our plugin install has not yet been run or its a newer version
	E["global"][CUI.PluginName] = E["global"][CUI.PluginName] or {}
	E.private[CUI.PluginName] = E.private[CUI.PluginName] or {}
	E.private.install_complete = E.version
	local _, _ , major, minor, build = string.find(CUI.Version, "(%d+).(%d+).(%d+)")
	local majorUser, minorUser, buildUser
	if E.db[CUI.PluginName].install_version ~= nil then
		_, _ ,majorUser, minorUser, buildUser = string.find(E.db[CUI.PluginName].install_version, "(%d+).(%d+).(%d+)")
	end
	if E.private.install_complete and (E.db[CUI.PluginName].install_version == nil or (majorUser ~= major or minorUser ~= minor)) then
	    E:GetModule("PluginInstaller"):Queue(CUI.InstallerData)
	end
	--Insert our options table when ElvUI config is loaded
	EP:RegisterPlugin(addon, InsertOptions)
end

--This function will get called by ElvUI automatically when it is ready to initialize modules
local function CallbackInitialize()
	mod:Initialize()
end

--Register module with callback so it gets initialized when ready
E:RegisterModule(CUI.PluginName, CallbackInitialize)
