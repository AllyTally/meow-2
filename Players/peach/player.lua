return (function()
    local self
    self = { }
    -- Don't touch anything before these lines
    
    self.name = "Peach" -- The player name. Unused by default.

    self.size = {2, 2} -- The player's size.
    self.speed = 3

    self.hitbox_size = {
        x = 46,
        y = 22
    }
    
    self.interaction_distance = 13 * 2

    self.animations = {
    --  Animation name    Filenames            Delay  Offset  Folder
        IdleLeft    = {  { "1"                }, 0  ,{12,29}, "WalkLeft"  },
        IdleRight   = {  { "1"                }, 0  ,{12,29}, "WalkRight" },
        IdleUp      = {  { "1"                }, 0  ,{12,29}, "WalkUp"    }, 
        IdleDown    = {  { "1"                }, 0  ,{12,29}, "WalkDown"  },
        WalkLeft    = {  { "0", "1", }, 10 ,{12,29}, "WalkLeft"  },
        WalkRight   = {  { "0", "1", }, 10 ,{12,29}, "WalkRight" },
        WalkUp      = {  { "0", "1", }, 10 ,{12,29}, "WalkUp"    },
        WalkDown    = {  { "0", "1", }, 10 ,{12,29}, "WalkDown"  },
    }
    function self.Update()
    end

    -- Don't touch anything after these lines
    return self
end)()
