local isOpen = false

local ringulaMouse_Current = {
    X = -1.0,
    Y = -1.0
}

local ringulaMouse_Target = {
    X = -1.0,
    Y = -1.0
}

local Ringula_defaultSettings = {
    buttonCount = 8, --How many buttons? 
    colorProfile = { cR = 0.0, cG = 0.0, cB = 0.0, cA = 0.0 },--coloring info.
	
    -- startPage = 13, --What index is the action page index? 
    -- radius = 100.0, --How big the circle is.
    -- animationSpeed = 0.0, --Animation speed for open/close. 
    -- transparency = 0.0, --Total transparency for whole bar and everything.
    -- totalScale = 0.0, --Scale whole ringula. making the buttons smaller. 
    -- autoClose = true --Automatically close when cursor goes far from origin.
}

-- Add delegations to Settings Menu in here
SLASH_RINGULA1 = "/ringula"
SLASH_RINGULA2 = "/ring"
SLASH_RINGULA3 = "/gula"
SLASH_RINGULA4 = "/rinkula"
SLASH_RINGULA5 = "/rinki"
SlashCmdList["RINGULA"] = function(msg)
   -- Show Settings for Ringula. file: RingulaSettings.lua
   RingulaSettingsFrame:Show()
end 

-- Settings (saved variables)
local RingulaSettings = {}

function Ringula_ResetDefaultSettings()
    RingulaSettings = {}
    for k, v in pairs(Ringula_defaultSettings) do
        RingulaSettings[k] = v
    end
end

-- Only updates fields that are not present in the current settings dictionary.
-- Used for initializing new settings with sensible initial values after a version update.
function Ringula_LoadNewDefaultSettings()
    for k, v in pairs(Ringula_defaultSettings) do
        if RingulaSettings[k] == nil then
            RingulaSettings[k] = v
        end
    end
end

function RingulaFrame_OnLoad()
    Ringula_ResetDefaultSettings()
    this:RegisterEvent("VARIABLES_LOADED")
end

function RingulaFrame_OnEvent(event)

    if event == "VARIABLES_LOADED" then
        Ringula_LoadNewDefaultSettings()
        CreateRingulaFrame()
        -- Setup Settings for Ringula. file: RingulaSettings.lua
        RingulaSettings_SetupSettingsFrame()
    end

end

function RingulaFrame_OnUpdate(elapsed)
    if (not isOpen) then
        RingulaFrame:Hide()
    end

    -- Button position update always?
    Ringula_UpdatePositions()
end

function CreateNewButton(buttonName)
    local button = CreateFrame("CheckButton", buttonName, RingulaFrame, "BonusActionButtonTemplate")
    -- Hide Hotkey text
    local hotkey = getglobal(buttonName .. "HotKey")
    hotkey:Hide()
    -- Hook individual button callbacks
    button.oldScriptOnClick = button:GetScript("OnClick")
    button:SetScript("OnClick", RingulaOnClick)
    button.oldScriptOnEnter = button:GetScript("OnEnter")
    button:SetScript("OnEnter", RingulaOnEnter)

    return button
end

-- Basically, search globals if there is a button, if NOT --> Create one.
function ButtonForId(i)
    local buttonName = "Nappula" .. i
    local button = getglobal(buttonName) 

    if not button then 
        button = CreateNewButton(buttonName)
    end

    return button
end

function ConfigureButtonWithId(button, i)
    button:SetID(1020 + i) -- TODO : WHAT ID...May conflict with other addons.
    button:SetPoint("CENTER", RingulaFrame, "CENTER", 0, 0)
    button:SetFrameLevel(2)
    button.isRingula = true
    button.isBonus = true
    button.buttonType = "RINGULA_MENU" --to do: Varmista, mihin tämä liittyy :D--
    button:Enable()
    button:Show()
end

function CreateRingulaFrame ()
    for i = 1, 8 do
        local button = ButtonForId(i)
        ConfigureButtonWithId(button, i)
        this = button
    end
    
    Ringula_UpdatePositions()
end

local function UpdateButton(buttonid, angleOffsetRadians, buttonCount, radius)
    local buttonName = "Nappula" .. buttonid
    local button = getglobal(buttonName) 
    local angle = angleOffsetRadians + 2.0 * math.pi * (buttonid - 1) / buttonCount
    local buttonX = radius * math.sin(angle)
    local buttonY = radius * math.cos(angle)
    button:SetPoint("CENTER", RingulaFrame, "CENTER", buttonX, buttonY)
    button:SetAlpha(200)   
end

-- Buttons are children of RingulaFrame(Main frame). 
-- 1. update button positions inside ringula frame, radial?
-- 2. update RingulaFrame position to where mouse is.
function Ringula_UpdatePositions()
    local radius = 100.0 --TODO Change these into default_settings
    Ringula_UpdateButtonPositions(radius)
    UpdateRingulaFramePosition(radius)
end

local function Ringula_UpdateButtonPositions(radius)
    local angleOffset = 6
    local angleOffsetRadians = angleOffset / 180.0 * math.pi
    local btnCount = RingulaSettings.buttonCount
    for i = 1, btnCount do
      UpdateButton(i, angleOffsetRadians, btnCount, radius) 
    end
end

local function UpdateRingulaFramePosition(radius)
    local colors = RingulaSettings.colorProfile
    local backdropAlpha = colors.cA
    RingulaTextureShadow:SetVertexColor(colors.cR,colors.cG,colors.cB, backdropAlpha);

    local backdropScale = 1.5 --TODO Change these into default_settings
    local size = 2 * radius * backdropScale

    -- Frame Positioning and Size.
    RingulaFrame:SetWidth(size)
    RingulaFrame:SetHeight(size)
    RingulaFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", ringulaMouse_Target.X, ringulaMouse_Target.Y)
end

function Ringula_GetMousePosition()
    local mouseX, mouseY = GetCursorPosition()
    local uiScale = RingulaFrame:GetParent():GetEffectiveScale()
    mouseX = mouseX / uiScale
    mouseY = mouseY / uiScale
    return mouseX, mouseY
end

local function Ringula_SetTargetToMouse()
    local mouseX, mouseY = Ringula_GetMousePosition()
    ringulaMouse_Target.X = mouseX
    ringulaMouse_Target.Y = mouseY
end

function CloseRingula()
    Ringula_SetTargetToMouse()
    isOpen = false
end

function OpenRingula ()
    Ringula_SetTargetToMouse()
    isOpen = true
    RingulaFrame:Show() --This has to be done because of upkeep.
end

--
-- Bind on key down- and up
--
function Ringula:BeginKeyInput ( keyIndex, modAlt, modControl, modShift )
    OpenRingula()
end

function Ringula:EndKeyInput( keyIndex )
    CloseRingula()
end
