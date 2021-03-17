function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 16,
        y = 27
    }

    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "spr_tornote"

    self.pressed = false
    
    self.solid = false
    
    function self.OnInteract()
        Audio.PlaySound("BeginBattle2")
    end
    

    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

