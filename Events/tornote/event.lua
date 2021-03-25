function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 16,
        y = 27
    }

    self.hitbox_offset = {
        x = 2,
        y = -5
    }

    self.sprite_offset = {
        x = 2,
        y = -5
    }

    self.sprite_path = "spr_tornote"

    self.solid = false

    function self.OnInteract()
        local text = self.properties["text"]
        text = text:gsub("\\r","\r")
        text = text:gsub("\\n","\n")

        Overworld.SpawnSimpleTextbox(text)

    end


    function self.Update() end
    return self -- Don't remove this line
end

return main() -- Don't remove this line

