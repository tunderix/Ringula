

RingulaRing = {};
RingulaRing.__index = RingulaRing;

function RingulaRing:create(ringId, hotkey, buttons, description)
   local ring = {};             -- our new object
   setmetatable(ring,RingulaRing);  -- make Account handle lookup


   ring.id = ringId;
   ring.hotkey = hotkey;
   ring.buttonContent = buttons;
   ring.description = description;

   return ring;
end

