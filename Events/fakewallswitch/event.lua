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
        Overworld.SpawnSimpleTextbox("This switch doesn't even\rwork...")
    end


    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

