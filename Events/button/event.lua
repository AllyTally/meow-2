function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 16,
        y = 14
    }

    self.hitbox_offset = {
        x = 2,
        y = 5
    }

    self.sprite_path = "button"

    self.pressed = false
    
    self.solid = false

    function self.OnCollide()
        if not self.pressed then
            self.sprite.Set(self.sprites_folder .. "button_pressed")
            Audio.PlaySound("BeginBattle2")
            self.pressed = true
        end
    end

    function self.Update()
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

