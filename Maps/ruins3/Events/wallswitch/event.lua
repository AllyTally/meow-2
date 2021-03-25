function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 7,
        y = 15
    }

    self.hitbox_offset = {
        x = -4,
        y = 5
    }

    self.sprite_offset = {
        x = -4,
        y = 5
    }

    self.sprite_path = "0"

    self.pressed = false
    
    self.solid = false
    
    function self.OnInteract()
        if not self.pressed then
            local switches = Overworld.FindEvents("wallswitch")

            local solved = true
            
            self.pressed = true
            
            for switch_id = 1, #switches do
                switch = switches[switch_id]
                if not switch.pressed then
                    solved = false
                    break
                end
            end



            self.sprite.Set(self.sprites_folder .. "1")
            if solved then
                Misc.ShakeScreen(16, 3)
                Audio.PlaySound("mechanical_sigh")
                local all_spikes = Overworld.FindEvents("spikes")
                
                for spikes_id = 1, #all_spikes do
                    local spikes = all_spikes[spikes_id]
                    spikes.sprite.Set(spikes.sprites_folder .. "1")
                    spikes.solid = false
                end
                
                if door then door.Destroy() end
            end
            
            
        end
    end
    

    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

