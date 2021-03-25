function main()
    local self
    self = { }

    self.hitbox_size = {
        x = 20,
        y = 20
    }

    self.hitbox_offset = {
        x = 0,
        y = 0
    }

    self.sprite_offset = {
        x = 0,
        y = 0
    }

    self.sprite_path = "empty"

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

