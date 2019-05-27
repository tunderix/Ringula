local isOpen = false

currentX = -1.0
currentY = -1.0
targetX = -1.0
targetY = -1.0

Ringula_defaultSettings = {
    NumButtonCount = 8, 
    StartPage = 13,
}

-- Settings (saved variables)
Ringula_settings = {}

function Ringula_ResetDefaultSettings()
    Ringula_settings = {}
    for k, v in pairs(Ringula_defaultSettings) do
        Ringula_settings[k] = v
    end
end



function RingulaFrame_OnLoad()
    Ringula_ResetDefaultSettings()
    CloseRingu_Menu()
    this:RegisterEvent("VARIABLES_LOADED")

end



function RingulaFrame_OnEvent(event)

    if event == "VARIABLES_LOADED" then
        ConfigureButtons()
    end

end



function RingulaFrame_OnUpdate(elapsed)
    Ringula_UpdateButtonPositions()
end

function Ringula_UpdateButtonPositions()
    -- Ring position
    RingulaFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", currentX, currentY)
end


function ToggleRingu_Menu()

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
    RingMenu_isOpen = false
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

function ConfigureButtons ()

    for i = 1, Ringula_settings.NumButtonCount do
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
        button:SetID(i)
        button:SetPoint("CENTER", RingulaFrame, "CENTER", 0, 0)
        button:SetFrameLevel(2)
        button.isRingula = true
        button.isBonus = true
        button.buttonType = "RINGULA_MENU" --to do: Varmista, mihin tämä liittyy :D--
       
        local icon = getglobal(buttonName .. "Icon")
        icon:SetTextCoord (0.0, 1.0, 0.0, 1.0) 
        button:Enable()
        button:Show()

        this = button
       -- ActionButton_Update() 

    end

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

