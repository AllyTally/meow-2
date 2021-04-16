function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 23,
        y = 36
    }

    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "amalgam1"

    self.solid = false

    function self.OnInteract()
        Overworld.SpawnSimpleTextbox("It's a white puddle of goop.")
    end

    return self -- Don't remove this line
end

return main() -- Don't remove this line

