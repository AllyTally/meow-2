return (function()
    local self
    self = { }
    -- Don't touch anything before these lines

    self.scale = {
        x = 2,
        y = 2
    }

    function self.BeforeLoad()   end -- Called right before the map is loaded
    function self.OnLoad()       end -- Called right after the map is loaded
    function self.AfterEnter()   end -- Called after the fade-in transition is finished
    function self.Update()       end -- Called every frame
    function self.OnLeave()      end -- Called the moment the fade-out transition starts
    function self.BeforeUnload() end -- Called right before the map gets unloaded

    -- Don't touch anything after these lines
    return self
end)()
