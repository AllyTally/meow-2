function main()
    local self
    self = { }
    self.hitbox_size = {
        x = 24,
        y = 18
    }
    self.hitbox_offset = {
        x = 1,
        y = 1
    }

    self.sprite_offset = {
        x = 4,
        y = 6
    }

    self.sprite_path = "spr_toriel_d/0"

    self.solid = true
    
    self.uses_depth = true
    self.depth_offset = 9

    self.animations = {
    --  Animation name    Filenames            Delay  Offset  Folder
        IdleLeft    = {  { "0"                }, 0  ,{12,29}, "spr_toriel_l"  },
        IdleRight   = {  { "0"                }, 0  ,{12,29}, "spr_toriel_r"  },
        IdleUp      = {  { "0"                }, 0  ,{12,29}, "spr_toriel_u"  }, 
        IdleDown    = {  { "0"                }, 0  ,{12,29}, "spr_toriel_d"  },
        WalkLeft    = {  { "0", "1", "2", "3" }, 10 ,{12,29}, "spr_toriel_l"  },
        WalkRight   = {  { "0", "1", "2", "3" }, 10 ,{12,29}, "spr_toriel_r"  },
        WalkUp      = {  { "0", "1", "2", "3" }, 10 ,{12,29}, "spr_toriel_u"  },
        WalkDown    = {  { "0", "1", "2", "3" }, 10 ,{12,29}, "spr_toriel_d"  },
        TalkLeft    = {  { "0", "1",          }, 10 ,{12,29}, "spr_toriel_lt" },
        TalkRight   = {  { "0", "1",          }, 10 ,{12,29}, "spr_toriel_rt" },
        TalkUp      = {  { "0", "1",          }, 10 ,{12,29}, "spr_toriel_ut" },
        TalkDown    = {  { "0", "1",          }, 10 ,{12,29}, "spr_toriel_dt" },
    }
    self.animation = "IdleDown"

    function self.Update()
        button_events = Overworld.FindEvents("button")

        
        for button_id = 1, #button_events do
            local button = button_events[button_id]
            if NPCHelper.AreEventsColliding(self,button) then
                button.OnCollide()
            end
        end
    
        NPCHelper.Animate(self)
    end

    return self -- Don't remove this line
end

return main() -- Don't remove this line

