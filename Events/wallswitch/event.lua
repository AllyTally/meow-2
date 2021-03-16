function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 7,
        y = 15
    }

    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "0"

    self.pressed = false
    
    self.solid = false
    
    function self.OnInteract()
        if not self.pressed then
            local buttons = Overworld.FindEvents("button")
            
            
            local solved = true
            for button_id = 1, #buttons do
                button = buttons[button_id]
                -- If a bad button is pressed, we fail
                if button.pressed and (not button.properties["good"]) then
                    solved = false
                    break
                end
                -- If a good button isn't pressed, we fail
                if not button.pressed and (button.properties["good"]) then
                    solved = false
                    break
                end
            end
            
            if solved then
                self.sprite.Set(self.sprites_folder .. "1")
                Audio.PlaySound("BeginBattle2")
                self.pressed = true
                local door = Overworld.FindFirstEvent("largedoor")
                if door then door.Destroy() end
            else
                Audio.PlaySound("BeginBattle2")
                for button_id = 1, #buttons do
                    button = buttons[button_id]
                    button.sprite.Set(button.sprites_folder .. "button")
                    button.pressed = false
                end
            end
            
            
        end
    end
    

    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

