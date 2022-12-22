local CUI = select(2, ...):unpack()

function CUI:PlaterImport(importDB)
  if importDB then
    PlaterDB["profiles"]["ChampUI"] = CUI.Plater.Profile
  end

  name = UnitName("PLAYER")
  realm = GetRealmName()
  --if we overwrite the PlaterDB to add our profiles it will forget which profile to load
  --set the profile key manually so the correct profile is selected after a reload
  PlaterDB["profileKeys"][name.." - "..realm] = "ChampUI"

 PluginInstallStepComplete.message = "Plater Profile Imported"
 PluginInstallStepComplete:Show()
end