
--
-- Creation of settings. 
--
function CreateSettingsFrame(config)
    local frame = CreateFrame("Frame", config.name, UIParent)
    local frameWidth = 360.0
    frame:SetWidth(frameWidth)
    frame:SetHeight(200)
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

    --TITLE COMPONENTS
    local titleTexture = CreateTitleTexture(config.name, frame)
    local titleFrame = CreateTitleText(config.name, frame, titleTexture, config.title)
    local titleHandle = CreateTitleHandle(config.name, frame)
     
    
    -- ROW generation
    local framePadding = 24.0
    local rowWidth = frameWidth - 2 * framePadding
    local currentY = framePadding + 18

    -- Creation of BUTTONS
    local numButtons = table.getn(config.buttons)
    local buttonPadding = 8
    local buttonWidth = (rowWidth - (numButtons - 1) * buttonPadding) / numButtons
    local buttonHeight = 18
    
    for i, buttonConf in ipairs(config.buttons) do
        local button = CreateFrame("Button", config.name .. "Button" .. buttonConf.name, frame, "UIPanelButtonTemplate")
        local xOffset = (i - 1) * (buttonWidth + buttonPadding)
        button:SetPoint("LEFT", frame, "TOPLEFT", framePadding + xOffset, -currentY)
        button:SetWidth(buttonWidth)
        button:SetHeight(buttonHeight)
        button:SetText(buttonConf.text)
        button:SetScript("OnClick", buttonConf.func)
    end

    frame:SetScript("OnShow", config.showFunc)
    return frame
end

-- Create title components

function CreateTitleText(name, parentFrame, titleTexture, title)
    local titleFrame = parentFrame:CreateFontString(name .. "TitleText", "ARTWORK", "GameFontNormal")
    titleFrame:SetText(title)
    titleFrame:SetPoint("TOP", titleTexture, "TOP", 0, -14)
    return titleFrame
end

function CreateTitleTexture(name, parentFrame)
    local titleTexture = parentFrame:CreateTexture(name .. "TitleTexture", "ARTWORK")
    titleTexture:SetTexture("Interface/DialogFrame/UI-DialogBox-Header")
    titleTexture:SetWidth(280)
    titleTexture:SetHeight(64)
    titleTexture:SetPoint("TOP", parentFrame, "TOP", 0, 12)
    return titleTexture
end

function CreateTitleHandle(name, parentFrame)
    local titleHandle = CreateFrame("Button", name .. "TitleHandle", parentFrame)
    titleHandle:SetWidth(280 - 2 * 64)
    titleHandle:SetHeight(64 - 2 * 14)
    titleHandle:SetPoint("TOP", parentFrame, "TOP", 0, 12)
    titleHandle:EnableMouse(true)
    titleHandle:RegisterForClicks("LeftButtonDown", "LeftButtonUp")
    titleHandle:SetScript("OnMouseDown", RingulaSettings_StartDragging)
    titleHandle:SetScript("OnMouseUp", RingulaSettings_StopDragging)
    return titleHandle
end


function RingulaSettings_SetupSettingsFrame()
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


--
-- Settings DRAGGING actions.
--

function RingulaSettings_StartDragging()
    if arg1 == "LeftButton" then
        RingulaSettingsFrame:StartMoving()
    end
end

function RingulaSettings_StopDragging()
    if arg1 == "LeftButton" then
        RingulaSettingsFrame:StopMovingOrSizing()
    end
end