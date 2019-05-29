
--
-- Creation of settings. 
--
function CreateSettingsFrame(config)
    local frame = CreateFrame("Frame", config.name, UIParent)
    local frameWidth = 360.0
    frame:SetWidth(frameWidth)
    frame:SetHeight(240)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
        tile = true, tileSize = 32, edgeSize = 32, 
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetToplevel(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)

    frame:SetScript("OnShow", config.showFunc)
    return frame
end

function RingMenuSettings_SetupSettingsFrame()
    local settingsFrameConfig = {
        name = "RingulaSettingsFrame",
        title = "Ringula Settings",
        showFunc = RingulaSettings_OnShow,
        rows = {
            { name = "Blank", text = "", widget = "none" },
            { name = "Description", text = "|cffccccccSelect a button to show / hide the RingMenu under \"Main Menu\" > \"Key Bindings\" > \"Open / Close RingMenu\"", widget = "none" },
        },
        buttons = {
            { name = "Okay", text = "Okay", func = RS_CloseOkay },
            { name = "Cancel", text = "Cancel", func = RS_CloseCancel },
            { name = "Default", text = "Reset", func = RS_Reset },
        },
    }

    RingulaSettingsFrame = CreateSettingsFrame(settingsFrameConfig)
    RingulaSettingsFrame:Hide()
end

function RingulaSettings_OnShow()
    PlaySound("GAMEDIALOGOPEN", "master")
    RingulaSettings_UpdateAllWidgets()
end


--
-- Updates for components.
-- 

function RingulaSettings_UpdateAllWidgets()
    
end




--
-- Settings Button ACTIONS
-- 

function RS_CloseOkay()
    PlaySound("GAMEDIALOGCLOSE", "master")
    RingulaSettingsFrame:Hide()
end

function RS_CloseCancel()
    PlaySound("GAMEDIALOGCLOSE", "master")
    ConfigureButtons()
    RingulaSettingsFrame:Hide()
end

function RS_Reset()
    PlaySound("GAMEGENERICBUTTONPRESS", "master")
    RingMenu_ResetDefaultSettings()
    RingMenuSettings_UpdateAllWidgets()
    ConfigureButtons()
end