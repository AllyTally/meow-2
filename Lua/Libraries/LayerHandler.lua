return (function()
    local self
    self = { }

    self.layers = {}

    -- type should be "tiles" or "image"
    -- cyf_layer should be a cyf layer (wow)
    function self.CreateLayer(_type,cyf_layer)
    
        if _type ~= "tiles" and _type ~= "image" then
            error("ally what",2)
        end

        local layer = {}

        layer.type = _type

        if _type == "tiles" then
            layer.sprite = CreateSprite("empty",cyf_layer)
            layer.tiles = {}
        end

        table.insert(self.layers,layer)
        return layer
    end

    return self 
end)()