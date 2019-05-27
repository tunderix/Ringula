local isOpen = false

currentX = -1.0
currentY = -1.0
targetX = -1.0
targetY = -1.0

Ringula_settings =
{
    NumButtonCount = 8, 
    StartPage = 13,

}

function RingulaFrame_OnLoad()

    CloseRingu_Menu()
    this:RegisterEvent("VARIABLES_LOADED")

end



function RingulaFrame_OnEvent(event)

    if event == "VARIABLES_LOADED"
    ConfigureButtons()
    end

end



function RingulaFrame_OnUpdate(arg1)

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
    local uiScale = RingMenuFrame:GetParent():GetEffectiveScale()
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
        button:SetPoint(:"CENTER", RingMenuFrame, "CENTER", 0, 0)
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

