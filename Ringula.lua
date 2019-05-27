local isOpen = false


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

    else

    end

end

function CloseRingu_Menu()


end

function OpenRingu_Menu ()


end


function RingMenu_GetMousePosition()
    local mouseX, mouseY = GetCursorPosition()
    local uiScale = RingMenuFrame:GetParent():GetEffectiveScale()
    mouseX = mouseX / uiScale
    mouseY = mouseY / uiScale
    return mouseX, mouseY
end

function ConfigureButtons ()

    for i = 1, Ringula_settings.NumButtonCount do
        
    end

end