local frameDimensions = {
    inset = 12,
    paddingTop = 36,
    paddingLeft = 16,
    paddingRight = 16,
    paddingBot = 24,
    width = 360,
    height = 200
}

local rowDimensions = {
    padding = 8,
    height = 18,
    splitHorizontal = 80
}

local buttonDimensions = {
    padding = 8,
    height = 18
}

local function buttonPositionX(i, buttonCount, buttonWidth)
    buttonsWidth = buttonCount * buttonWidth
    offsetX = (frameDimensions.width - buttonsWidth) /2 -- for centering
    posX = (i-1) * buttonWidth + offsetX -- calculation of X position
    return posX
end

local function create_slider(row, frame, rowPosY, width)
    local widget = CreateFrame("Slider", row.name .. "Widget" .. row.name, frame, "OptionsSliderTemplate")
    widget:SetPoint("LEFT", frame, "TOPLEFT", rowDimensions.splitHorizontal, rowPosY)
    widget:SetWidth(width)
    widget:SetHeight(17)
    widget:SetMinMaxValues(row.min, row.max)
    widget:SetValue((row.max - row.min) / 2)
    widget:SetValueStep(row.valueStep)
    local lowLabel = row.min
    local highLabel = row.max
    if row.labelSuffix then
        lowLabel = lowLabel .. row.labelSuffix
        highLabel = highLabel .. row.labelSuffix
    end
    getglobal(widget:GetName().."Low"):SetText(lowLabel)
    getglobal(widget:GetName().."High"):SetText(highLabel)
    widget:SetScript("OnValueChanged", row.updateFunc)
end

-- ROW Label Creation
local function createLabel(i, row, frame, rowPosY)
    local label = frame:CreateFontString(row.name .. "Label" .. row.name, "ARTWORK", "GameFontNormal")
    label:SetText(row.text .. i)
    label:SetPoint("LEFT", frame, "TOPLEFT", frameDimensions.paddingLeft, rowPosY)
    label:SetWidth(rowDimensions.splitHorizontal - frameDimensions.paddingLeft)
    label:SetJustifyH("LEFT")
end

-- ROW generation
function createRowFrom(i, row, frame)
    totalRowWidth = frameDimensions.width - frameDimensions.paddingLeft - frameDimensions.paddingRight
    rowPosY = -frameDimensions.paddingTop - i*rowDimensions.height
    componentWidth = (totalRowWidth - rowDimensions.splitHorizontal) - frameDimensions.paddingRight

    createLabel(i, row, frame, rowPosY)
    row.createFunc(row, frame, rowPosY, componentWidth)

end

function createButtonRow(frame, config)

    -- Creation of BUTTONS
    local buttonCount = table.getn(config.buttons)
    local buttonWidth = (frameDimensions.width / buttonCount) - buttonDimensions.padding 

    for i, buttonConf in ipairs(config.buttons) do
        local button = CreateFrame("Button", config.name .. "Button" .. buttonConf.name, frame, "UIPanelButtonTemplate")
        local btnDim = {
            X = buttonPositionX(i, buttonCount, buttonWidth),
            Y = frameDimensions.paddingBot
        }
        button:SetPoint("LEFT", frame, "BOTTOMLEFT", btnDim.X, btnDim.Y)
        button:SetWidth(buttonWidth)
        button:SetHeight(buttonDimensions.height)
        button:SetText(buttonConf.text)
        button:SetScript("OnClick", buttonConf.func)
    end
end

function CreateSettingsFrameContents(config, frame)
    
    for i, row in ipairs(config.rows) do
        createRowFrom(i, row, frame)
    end

    createButtonRow(frame, config)
end
--
-- Creation of settings. 
--
function CreateSettingsFrame(config)
    local frame = CreateFrame("Frame", config.name, UIParent)
    frame:SetWidth(frameDimensions.width)
    frame:SetHeight(frameDimensions.height)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetBackdrop({
        bgFile = "Interface/DialogFrame/UI-DialogBox-Background", 
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border", 
        tile = true, tileSize = 32, edgeSize = 32, 
        insets = { 
            left = frameDimensions.inset, 
            right = frameDimensions.inset, 
            top = frameDimensions.inset, 
            bottom = frameDimensions.inset 
        }
    })
    frame:SetToplevel(true)
    frame:SetMovable(true)
    frame:EnableMouse(true)

    --TITLE COMPONENTS
    local titleTexture = CreateTitleTexture(config.name, frame)
    local titleFrame = CreateTitleText(config.name, frame, titleTexture, config.title)
    local titleHandle = CreateTitleHandle(config.name, frame)
     
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
            { name = "Radius", text = "Radius", createFunc = create_slider, min = 0, max = 300, labelSuffix = " px", valueStep = 1, updateFunc = RingulaRadiusOnUpdate },
            { name = "Radius", text = "Radius", createFunc = create_slider, min = 0, max = 300, labelSuffix = " px", valueStep = 1, updateFunc = RingulaRadiusOnUpdate },
            { name = "Radius", text = "Radius", createFunc = create_slider, min = 0, max = 300, labelSuffix = " px", valueStep = 1, updateFunc = RingulaRadiusOnUpdate },
            { name = "Radius", text = "Radius", createFunc = create_slider, min = 0, max = 300, labelSuffix = " px", valueStep = 1, updateFunc = RingulaRadiusOnUpdate },
        },
        buttons = {
            { name = "Okay", text = "Okay", func = RS_CloseOkay },
            { name = "Cancel", text = "Cancel", func = RS_CloseCancel },
            { name = "Default", text = "Reset", func = RS_Reset },
        },
    }

    RingulaSettingsFrame = CreateSettingsFrame(settingsFrameConfig)
    CreateSettingsFrameContents(settingsFrameConfig, RingulaSettingsFrame)
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

-- 
-- WIDGET Delegates
--

function RingulaRadiusOnUpdate()
    --local slider = getglobal("RingMenuSettingsFrameWidgetRadius")
    --RingMenu_settings.radius = slider:GetValue()
    --RingMenuSettings_UpdateSliderLabels()
    --RingMenu_UpdateButtonPositions()
end