local isOpen = false

local currentX = -1.0
local currentY = -1.0
local targetX = -1.0
local targetY = -1.0

local Ringula_defaultSettings = {
    NumButtonCount = 8, 
    StartPage = 13,
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

function Ringula_LoadNewDefaultSettings()
    -- Only updates fields that are not present in the current settings dictionary.
    -- Used for initializing new settings with sensible initial values after a version update.
    for k, v in pairs(Ringula_defaultSettings) do
        if RingulaSettings[k] == nil then
            RingulaSettings[k] = v
        end
    end
end

function RingulaFrame_OnLoad()
    Ringula_ResetDefaultSettings()
    CloseRingu_Menu()
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
    Ringula_UpdateButtonPositions()
    if (not isOpen) then 
        RingulaFrame:Hide() 
    end
end

function CreateRingulaFrame ()


    for i = 1, 8 do
        local buttonName = "Nappula" .. i
        local button = getglobal(buttonName) 
        if not button then 
            button = CreateFrame("CheckButton", buttonName, RingulaFrame, "BonusActionButtonTemplate")
            -- Hide Hotkey text
            local hotkey = getglobal(buttonName .. "HotKey")
            hotkey:Hide()
            -- Hook individual button callbacks
            button.oldScriptOnClick = button:GetScript("OnClick")
            button:SetScript("OnClick", RingulaOnClick)
            button.oldScriptOnEnter = button:GetScript("OnEnter")
            button:SetScript("OnEnter", RingulaOnEnter)
            
        end
        button:SetID(1020 + i) -- TODO : WHAT ID...May conflict with other addons.
        button:SetPoint("CENTER", RingulaFrame, "CENTER", 0, 0)
        button:SetFrameLevel(2)
        button.isRingula = true
        button.isBonus = true
        button.buttonType = "RINGULA_MENU" --to do: Varmista, mihin tämä liittyy :D--
       
        -- local icon = getglobal(buttonName .. "Icon")
        -- icon:SetTextCoord (0.0, 1.0, 0.0, 1.0) 
        button:Enable()
        button:Show()

        this = button
       -- ActionButton_Update() 

       --message("Button " .. buttonName .. "position is: " )

    end

    Ringula_UpdateButtonPositions()
end

function Ringula_UpdateButtonPositions()

    local radius = 100.0 --TODO Change these into default_settings
    local angleOffset = 6
    local angleOffsetRadians = angleOffset / 180.0 * math.pi
    local currentSize = 1

     -- Button positions
     for i = 1, RingulaSettings.NumButtonCount do
         local buttonName = "Nappula" .. i
         local button = getglobal(buttonName) 
         local angle = angleOffsetRadians + 2.0 * math.pi * (i - 1) / RingulaSettings.NumButtonCount
         local buttonX = radius * math.sin(angle)
         local buttonY = radius * math.cos(angle)
         button:SetPoint("CENTER", RingulaFrame, "CENTER", buttonX, buttonY)
         button:SetAlpha(200)
     end

    local colorR = 10.0 --TODO Change these into default_settings
    local colorG = 0.0 --TODO Change these into default_settings
    local colorB = 0.0 --TODO Change these into default_settings
    local colorAlpha = 0.5 --TODO Change these into default_settings
    local backdropAlpha = currentSize * colorAlpha
    RingulaTextureShadow:SetVertexColor(colorR,colorG,colorB, backdropAlpha);


    local backdropScale = 1.5 --TODO Change these into default_settings
    local size = currentSize * 2 * radius * backdropScale
    RingulaFrame:SetWidth(size)
    RingulaFrame:SetHeight(size)
    -- Ring position
    RingulaFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", targetX, targetY)
end


function Toggle_Ringula()

    if isOpen then 
        CloseRingu_Menu()  
    else
        OpenRingu_Menu ()
    end

end

function CloseRingu_Menu()
    local mouseX, mouseY = Ringula_GetMousePosition()
    
    targetX = mouseX
    targetY = mouseY
    isOpen = false
    
    
end

function OpenRingu_Menu ()
    local mouseX, mouseY = Ringula_GetMousePosition()
    targetX = mouseX
    targetY = mouseY
    isOpen = true
    
    RingulaFrame:Show()

    
end

function Ringula_GetMousePosition()
    local mouseX, mouseY = GetCursorPosition()
    local uiScale = RingulaFrame:GetParent():GetEffectiveScale()
    mouseX = mouseX / uiScale
    mouseY = mouseY / uiScale
    return mouseX, mouseY
end


function RingulaOnClick ()

    this:oldScriptOnClick()
    if IsShiftKeyDown() or CursorHasSpell() or CursorHasItem() then
        -- User is just changing button slots, keep RingMenu open
    else
        -- Clicked a button, close RingMenu
        CloseRingu_Menu()
    end
   
end

function RingulaOnEnter()
    if isOpen then
        this:oldScriptOnEnter()
    end
end


   