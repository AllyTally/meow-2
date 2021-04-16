function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 34,
        y = 24
    }

    self.hitbox_offset = {
        x = 0,
        y = -24
    }

    self.sprite_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "off"

    self.on = false
    
    self.solid = false

    function self.OnInteract()
        plot = 1
        local text_list = {}

        if self.properties["pages"] and self.properties["pages"] > 1 then
            for page = 1, self.properties["pages"] do
                local text = self.properties["text" .. page]
                text = text:gsub("\\r","\r")
                text = text:gsub("\\n","\n")
                table.insert(text_list, text)
            end
        else
            local text = self.properties["text"]
            text = text:gsub("\\r","\r")
            text = text:gsub("\\n","\n")
            table.insert(text_list, text)
        end

        local options = {
            top = false
        }
        Overworld.SpawnSimpleTextbox(text_list, nil, options)
    end
    

    function self.Update()
        if not self.on then
            if Overworld.player.x + Overworld.player.hitbox_size.x >= self.x and Overworld.player.x <= self.x + (self.hitbox_size.x * Overworld.mapdata.scale.x) then
                self.on = true
                self.sprite.Set(self.sprites_folder .. "on1")
                self.sprite.Set(self.sprites_folder .. "on2")
                self.sprite.Set(self.sprites_folder .. "on3")
                self.sprite.Set(self.sprites_folder .. "on4")
                self.sprite.SetAnimation({"on1","on2","on3","on4"}, 20/60, self.sprites_folder)
                Audio.PlaySound("menumove")
            end
        end
    end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

