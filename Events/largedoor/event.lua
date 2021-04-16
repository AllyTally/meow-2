function main()
    local self
    self = { }
    self.hitbox_size = {
        x = 34,
        y = 20
    }
    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_offset = {
        x = 0,
        y = 2
    }

    self.sprite_path = "door"
    self.pressed = false
    self.solid = true
    
    self.uses_depth = true
    self.depth_offset = 20

    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

