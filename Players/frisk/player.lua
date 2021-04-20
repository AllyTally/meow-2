return (function()
    local self
    self = { }
    -- Don't touch anything before these lines
    
    self.name = "Frisk" -- The player name. Unused by default.
    
    self.xp = 0
    self.gold = 0
    self.lv = 1

    self.size = {1, 1} -- The player's size.
    self.speed = 3

    self.hitbox_size = {
        x = 36,
        y = 22
    }
    
    self.soul_position = {
        x = 20,
        y = 20
    }
    
    self.interaction_distance = 13 * 2

    self.animations = {
    --  Animation name    Filenames            Delay  Offset  Folder
        IdleLeft    = {  { "0"                }, 0  ,{12,29}, "IdleLeft"  },
        IdleRight   = {  { "0"                }, 0  ,{12,29}, "IdleRight" },
        IdleUp      = {  { "0"                }, 0  ,{12,29}, "IdleUp"    }, 
        IdleDown    = {  { "0"                }, 0  ,{12,29}, "IdleDown"  },
        WalkLeft    = {  { "0", "1", "2", "1" }, 10 ,{12,29}, "WalkLeft"  },
        WalkRight   = {  { "1", "2", "1", "0" }, 10 ,{12,29}, "WalkRight" },
        WalkUp      = {  { "0", "1", "2", "1" }, 10 ,{12,29}, "WalkUp"    },
        WalkDown    = {  { "0", "1", "2", "1" }, 10 ,{12,29}, "WalkDown"  },
    }
    function self.Update()
    end

    -- Don't touch anything after these lines
    return self
end)()
