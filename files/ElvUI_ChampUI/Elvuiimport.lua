local CUI = select(2, ...):unpack()
local E, L, V, P, G = unpack(ElvUI)

function CUI:ElvUIImport(layout, importDB)

  --Don't update the profile settings unless we mean to
  if importDB then
    --this adds in all the profile settigns
    ElvDB["profiles"]["ChampUI DPS & Tank"] = CUI.ElvUI.Dps
    ElvDB["profiles"]["ChampUI Healer"] = CUI.ElvUI.Heal
    ElvDB["profiles"]["ChampUI CWA"] = CUI.ElvUI.CWA
  end

  --switch to the profile we want.
  if layout == "normal" then
    E.data:SetProfile("ChampUI DPS/Tank")
  elseif layout == "healer" then
    E.data:SetProfile("ChampUI Healer")
  elseif layout == "cwa" then
    E.data:SetProfile("ChampUI Class WA")
  end

  --disable the totem bar
  E.private["general"]["totemBar"] = false

  --character blizz font replacement settings
  E.private["general"]["dmgfont"] = "Poppins-SemiBold"
  E.private["general"]["namefont"] = "Poppins-SemiBold"

  --set the UI scale to 0.71
  ElvDB["global"]["general"]["UIScale"] = 0.71

  --Keep the font from resetting to default
  E.db["general"]["font"] = "Poppins-SemiBold"
	E:UpdateMedia();
	E:UpdateFontTemplates()

  --Evoker Empowered abilites fix. This will need to be removed at some point in the future
  --ElvUI/Blizz just needs to put out an update to fix this problem
  SetCVar('ActionButtonUseKeyDown', 1)
  ElvUI[1]:GetModule('ActionBars'):UpdateButtonSettings()
  SetCVar("empowerTapControls",1)

  --re-enabled the ElvUI incompatility warning
  --do it here so we know it wasn't on when we don't want the warning
  --but we know it'll be on for the user in the future even if they don't complete the installer.
	E.global.ignoreIncompatible = false

  PluginInstallStepComplete.message = "ElvUI Profiles Imported"
  PluginInstallStepComplete:Show()
end