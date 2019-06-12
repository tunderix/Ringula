--[[ 
local defaultRings = [
    {
        id = -1,
        hotkey = "",
        buttonContent = [],
        description = "Default Ring: Should Not Be SEEN"
    },
    {
        id = 0,
        hotkey = "",
        buttonContent = [],
        description = "Ringula by id: 0"
    },
    {
        id = 1,
        hotkey = "",
        buttonContent = [],
        description = "Ringula by id: 1"
    },
    {
        id = 2,
        hotkey = "",
        buttonContent = [],
        description = "Ringula by id: 2"
    },
    {
        id = 3,
        hotkey = "",
        buttonContent = [],
        description = "Ringula by id: 3"
    },
], -- Handle rings and their buttons and their identifiers.
 ]]




RingulaManager = {}
RingulaManager.__index = RingulaManager

function RingulaManager:create(ringData, defaultActiveRing)
   local manager = {}             -- our new object
   setmetatable(manager,RingulaManager)  -- make Account handle lookup
   manager.rings = ringData
   manager.activeRing = defaultActiveRing
   return manager
end

function RingulaManager:GetRingById(id)
    local rRing = self.rings[-1];
    if(id < table.getn(self.rings) && id > -1){
        rRing = self.rings[id];
    }
    return rRing;
end

function Ringula:GetActiveRing()
    return Ringula:GetRingById(self.activeRing);
end


--[[ 


function Ringula:GetButtonByID( index )
    return RingulaSettings.Buttons[index];
end

function Ringula:GetKeyByID( index )
    return RingulaSettings.Hotkeys[index];
end

function Ringula:GetHotkeyCount()
    return table.getn( RingulaSettings.Hotkeys );
end

function Ringula:GetButtonCount()
    return table.getn( RingulaSettings.Buttons );
end
 ]]