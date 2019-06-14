
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
]; -- Handle rings and their buttons and their identifiers.





RingulaManager = {};
RingulaManager.__index = RingulaManager;

function RingulaManager:create( ringData, defaultActiveRing )
   local manager = {};

   setmetatable(manager,RingulaManager);
   manager.rings = ringData;
   manager.activeRing = defaultActiveRing; --Int for active ring

   return manager;
end

--
-- Ring initialization
--
local function RingulaManager:Initialize()
    RingulaManager:InitializeRings();
end

local function RingulaManager:InitializeRings()
    local ringulaRings = [];

    for i=0, table.getn( defaultRings ) do
        ringulaRings[i] = RingulaManager:InitializeRing( i, defaultRings.hotkey, defaultRings.buttonContent, defaultRings.description );
    end
    
    self.rings = ringulaRings;
end

local function RingulaManager:InitializeRing(id, hotkey, buttons, description)
    return RingulaRing:create( ringId, hotkey, buttons, description );
end
--
-- Ring Management
--
function RingulaManager:GetRingById(id)
    local rRing = self.rings[-1];

    if id < table.getn( self.rings ) and id > -1 then
        rRing = self.rings[id];
    end

    return rRing;
end

function RingulaManager:GetActiveRing()
    return RingulaManager:GetRingById( self.activeRing );
end

function RingulaManager:RingCount()
    return table.getn( self.rings );
end

--Return false when id is NOT VALID
function RingulaManager:SetActiveRing(id)
    local success = false;

    if id < RingulaManager:RingCount() and id > 0 then
        self.activeRing = id;
        success = true;
    end
    
    return success; 
end
